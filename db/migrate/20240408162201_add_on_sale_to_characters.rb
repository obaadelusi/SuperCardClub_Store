class AddOnSaleToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :onSale, :boolean
  end
end
