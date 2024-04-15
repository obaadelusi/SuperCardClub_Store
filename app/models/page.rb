class Page < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "id_value", "slug", "title", "updated_at"]
  end

  validates :title, presence: true, length: { minimum: 2 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug

  private
    def generate_slug
      self.slug = title.parameterize if title.present? && slug.blank?
    end
end
