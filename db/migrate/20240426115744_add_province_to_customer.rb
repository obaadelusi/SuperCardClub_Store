class AddProvinceToCustomer < ActiveRecord::Migration[7.1]
  def change
    add_reference :customers, :province, null: true, foreign_key: true
  end
end
