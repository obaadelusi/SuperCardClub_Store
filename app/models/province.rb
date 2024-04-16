class Province < ApplicationRecord
  has_many :customers

  def self.ransackable_attributes(auth_object = nil)
    ["abbreviation", "country", "created_at", "id", "id_value", "name", "updated_at"]
  end
end
