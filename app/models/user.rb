class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :practiced_activities, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
