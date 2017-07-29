class AddErrorTextToProductImports < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_product_imports, :error_text, :string
  end
end
