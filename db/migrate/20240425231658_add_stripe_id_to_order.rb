class AddStripeIdToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :stripe_payment_id, :string
  end
end
