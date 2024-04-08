class Character < ApplicationRecord
  validates :name, presence: true

  belongs_to :publisher
  belongs_to :race
  belongs_to :alignment

  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    ["alignment_id", "created_at", "description", "id", "id_value", "name", "price", "publisher_id", "race_id", "stat_combat", "stat_durability", "stat_intelligence", "stat_power", "stat_speed", "stat_strength", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["alignment", "publisher", "race", "image_attachment", "image_blob"]
  end
end
