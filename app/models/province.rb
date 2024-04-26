class Province < ApplicationRecord
  validates :name, :country, presence: true
  validates :hst, :gst, :pst, numericality: { allow_nil: true }

  has_many :customers

  def self.ransackable_attributes(auth_object = nil)
    ["abbreviation", "country", "created_at", "id", "id_value", "name", "updated_at"]
  end
end
