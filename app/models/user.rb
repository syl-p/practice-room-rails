class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :media
  has_many :practiced_activities, dependent: :destroy
  has_many :practices
  has_many :notifications
  has_and_belongs_to_many :favorites, class_name: "Activity", join_table: "favorites"

  has_many :follows_as_following, class_name: "Follow", foreign_key: "follower_id"
  has_many :following, through: :follows_as_following

  has_many :follows_as_follower, class_name: "Follow", foreign_key: "following_id"
  has_many :followers, through: :follows_as_follower

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :password, confirmation: true, length: { minimum: 6 }, allow_blank: true

  has_one_attached :avatar
  def practice_time_today
    Rails.cache.fetch("practice_time_today:#{username}:#{Date.today.to_s}") do
      practiced_activities.today.sum(:duration)
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
