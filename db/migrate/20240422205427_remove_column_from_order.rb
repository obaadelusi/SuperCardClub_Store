class RemoveColumnFromOrder < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :tax_rate, :decimal

    add_column :orders, :hst, :decimal
    add_column :orders, :gst, :decimal
    add_column :orders, :pst, :decimal
  end
end
