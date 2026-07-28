class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :media
  has_many :practice_entries, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :goals
  has_many :notifications
  has_and_belongs_to_many :bookmarks, class_name: "Activity", join_table: "bookmarks"

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :password, confirmation: true, length: { minimum: 6 }, allow_blank: true

  has_one_attached :avatar

  validate :check_file_extension
  validate :check_file_size

  after_touch :delete_cached_practices

  def cached_practices
    today = Date.current
    cache_key = [ self, "practices", today ]
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      practices.left_joins(:today_entries)
               .group("practices.id")
               .select("practices.*, COALESCE(SUM(practice_entries.duration),0) as duration")
    end
  end

  def delete_cached_practices
    cache_key = [ self, "practices", Date.current ]
    Rails.cache.delete(cache_key)
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

  def check_file_extension
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add :avatar, "Must be a valid file extension"
    end
  end

  def check_file_size
    return unless avatar.attached?

    if avatar.blob.byte_size > 3.megabytes
      errors.add :avatar, "Must be a valid file size"
    end
  end
end
