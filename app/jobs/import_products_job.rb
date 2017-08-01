class ImportProductsJob < ActiveJob::Base
  queue_as :default

  after_perform :notify_admin

  rescue_from(StandardError) do |exception|
    Spree::UserMailer.product_import_results(@user, @store, exception.message + " " + exception.backtrace.join("\n")).deliver
    @products.error_text = exception.message + ' ' + exception.backtrace.inspect
    @products.failure
  end

  def perform(products, current_store, current_user)
    @products = products
    @store = current_store
    @user = current_user
    @products.import_data!(Spree::ProductImport.settings[:transaction])
  end

  def notify_admin
    Spree::UserMailer.product_import_results(@user, @store).deliver
    puts "*********************************************************"
    puts "*********************************************************"
    puts "==================== Import Complete ===================="
    puts "*********************************************************"
    puts "*********************************************************"
  end
end
