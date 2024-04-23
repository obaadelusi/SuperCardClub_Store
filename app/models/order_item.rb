class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :character

  def self.ransackable_attributes(auth_object = nil)
    ["character_id", "created_at", "id", "id_value", "order_id", "price", "quantity", "updated_at"]
  end
end
