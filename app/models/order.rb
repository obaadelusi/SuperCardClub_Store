class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "grand_total", "id", "id_value", "status", "pst", "gst", "hst", "tax_rate", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items"]
  end
end
