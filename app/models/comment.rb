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

  def notify_author_and_mentions
    Comments::NotificationsJob.perform_later(self.id, @mentioned_users.pluck(:id))
  end
end
