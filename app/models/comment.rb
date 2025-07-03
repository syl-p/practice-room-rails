class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers
  attr_accessor :users_mentioned
  validates :content, presence: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  # Associations
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  belongs_to :commentable, polymorphic: true

  before_create :check_mentions
  after_create :notify_user
  after_create :notify_mentioned_users

  attr_writer

  private
  def check_mentions
    username_mentioned = []

    content.gsub(/@(\w+)/) do |mention|
      username_mentioned << mention[1..-1]
    end

    @users_mentioned = User.where(username: username_mentioned)
    @users_mentioned.each do |user|
      link = `<a href="#{user_path(user)}" data-turbo="false">#{user.username}</a>`
      content.gsub!("@#{user.username}", link)
    end
  end

  def notify_user
    Notification.create(user: commentable.user, notifiable: self, notification_type: :comment)
  end

  def notify_mentioned_users
    @users_mentioned.each do |user|
      Notification.create(user: user, notifiable: self, notification_type: :mention)
    end
  end
end
