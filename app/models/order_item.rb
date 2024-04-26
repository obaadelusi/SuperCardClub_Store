class OrderItem < ApplicationRecord
  validates :quantity, :price, presence: true
  validates :quantity, :price, numericality: true

  belongs_to :order
  belongs_to :character

  def self.ransackable_attributes(auth_object = nil)
    ["character_id", "created_at", "id", "id_value", "order_id", "price", "quantity", "updated_at"]
  end

  def to_s
    "#{self.character.name}(x#{self.quantity})"
  end
end
