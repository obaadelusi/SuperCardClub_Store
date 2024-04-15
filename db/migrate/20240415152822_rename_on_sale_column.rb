class RenameOnSaleColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :characters, :onSale, :on_sale
  end
end
