class AddAttributesToCustomers < ActiveRecord::Migration[7.1]
  # def change
  #   add_column :customers, :first_name, :string
  #   add_column :customers, :last_name, :string
  #   add_column :customers, :street, :string
  #   add_column :customers, :city, :string
  #   add_reference :customers, :province, foreign_key: true
  #   add_column :customers, :country, :string
  # end

  def change
    add_column :customers, :postal_code, :string
  end
end
