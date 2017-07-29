class ImportProductsJob < ActiveJob::Base
  queue_as :default

  after_perform :notify_admin

  rescue_from(StandardError) do |exception|
    Spree::UserMailer.product_import_results(Spree::User.admin.first, exception.message + " " + exception.backtrace.join("\n")).deliver_later
    @products.error_text = exception.message + ' ' + exception.backtrace.inspect
    @products.failure
  end

  def perform(products)
    @products = products
    @products.import_data!(Spree::ProductImport.settings[:transaction])
  end

  def notify_admin
    Spree::UserMailer.product_import_results(Spree::User.admin.first).deliver_later
    puts "*********************************************************"
    puts "*********************************************************"
    puts "==================== Import Complete ===================="
    puts "*********************************************************"
    puts "*********************************************************"
  end
end
