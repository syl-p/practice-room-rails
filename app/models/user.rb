class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :media
  has_many :practice_entries, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :notifications
  has_and_belongs_to_many :bookmarks, class_name: "Activity", join_table: "bookmarks"
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :password, confirmation: true, length: { minimum: 6 }, allow_blank: true

  has_one_attached :avatar

  def cached_practices
    cache_key = [ self, "practices", Date.current ]
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      practices.left_joins(:practice_entries)
               .select("practices.*, COALESCE(SUM(practice_entries.duration),0) as duration")
               .group("practices.id")
    end
  end

  def update_with_password(params)
    if User.authenticate_by(email_address: params[:email_address], password: params[:current_password])
      params.delete(:current_password)
      update(params)
    else
      errors.add(:current_password, "est invalide")
      false
    end
  end

  def update_without_password(params)
    params.delete(:current_password)
    params.delete(:password)
    params.delete(:password_confirmation)
    update(params)
  end
end
