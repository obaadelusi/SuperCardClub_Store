class AddColumnsToCustomer < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :street, :string
    add_column :customers, :city, :string
    # add_reference :customers, :province, null: false, foreign_key: true
    # add_column :customers, :postal_code, :string
  end
end
