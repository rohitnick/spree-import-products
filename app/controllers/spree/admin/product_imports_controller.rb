module Spree
  module Admin
    class ProductImportsController < BaseController

      def index
        @product_import = Spree::ProductImport.new
        @product_imports = Spree::ProductImport.order("created_at DESC").limit(Spree::Config[:admin_products_per_page] || 10)
      end

      def show
        @product_import = Spree::ProductImport.find(params[:id])
        @products = @product_import.products
      end

      def create
        @product_import = Spree::ProductImport.create(product_import_params)
        begin
          ImportProductsJob.perform_later(@product_import, current_store, spree_current_user)
          flash[:notice] = t('product_import_processing')
        rescue StandardError => e
          @product_import.error_text=e.message+ ' ' + e.backtrace.inspect
          @product_import.failure
          flash[:error] = t('product_import_error')
        end
        redirect_to admin_product_imports_path
      end

      def destroy
        @product_import = Spree::ProductImport.find(params[:id])
        if @product_import.destroy
          flash[:notice] = t('delete_product_import_successful')
        end
        redirect_to admin_product_imports_path
      end

      private
        def product_import_params
          params.require(:product_import).permit!
        end
    end
  end
end
