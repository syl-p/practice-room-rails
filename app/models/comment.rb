class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers
  attr_accessor :mentioned_users
  validates :content, presence: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  # Associations
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  belongs_to :commentable, polymorphic: true

  before_create :extract_and_replace_mentions
  after_create :notify_author_and_mentions

  private
  def extract_and_replace_mentions
    usernames = content.to_s.scan(/@(\w+)/).flatten.uniq
    @mentioned_users = User.where(username: usernames)

    @mentioned_users.each do |user|
      link = %Q(<a href="#{user_path(user)}" data-turbo="false">#{user.username}</a>)
      self.content = content.gsub("@#{user.username}", link)
    end
  end

  def notify_author
    Notification.create(user: commentable.user, notifiable: self, notification_type: :comment)
  end

  def notify_mentioned_users
    @mentioned_users.each do |user|
      Notification.create(user: user, notifiable: self, notification_type: :mention)
    end
  end

  def notify_author_and_mentions
    notify_author if commentable.user != user
    notify_mentioned_users
  end
end
