class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :practiced_activities, dependent: :destroy
  has_many :practices
  has_and_belongs_to_many :favorites, class_name: "Activity", join_table: "favorites"

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :password, confirmation: true, length: { minimum: 6 }, allow_blank: true

  has_one_attached :avatar
  def practice_time_today
    practiced_activities.today.sum(:duration)
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
