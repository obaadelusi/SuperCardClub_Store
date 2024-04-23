class Customer < ApplicationRecord

  belongs_to :province, optional: true
  has_many :orders

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # before_action :authenticate_customer!

  def self.ransackable_attributes(auth_object = nil)
  ["created_at", "email", "encrypted_password", "first_name", "last_name", "street", "city", "province_id", "country", "postal_code", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
  ["order", "province"]
  end
end
