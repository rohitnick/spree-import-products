class AddProductIdsToProductImports < ActiveRecord::Migration[4.2]
  def change
    add_column  :spree_product_imports, :product_ids, :text
  end
end