class RenameProductImportsTableToSpreeProductImports < ActiveRecord::Migration[4.2]
  def change
    rename_table :product_imports, :spree_product_imports
	end
end
