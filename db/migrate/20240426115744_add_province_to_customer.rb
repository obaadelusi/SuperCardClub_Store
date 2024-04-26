class AddProvinceToCustomer < ActiveRecord::Migration[7.1]
  def change
    add_reference :customers, :province, null: false, foreign_key: true
  end
end
