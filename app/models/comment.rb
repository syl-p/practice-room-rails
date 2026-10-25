class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :content, presence: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  # root comments only
  scope :top_level, -> { where(parent_id: nil).order(created_at: :desc) }

  # Associations
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  belongs_to :commentable, polymorphic: true

  before_create :extract_mentions
  after_create :notify_author_and_mentions

  private
  def extract_mentions
    usernames = content.to_s.scan(/@(\w+)/).flatten.uniq
    @mentioned_users = User.where(username: usernames)
  end

  def notify_author_and_mentions
    Comments::NotificationsJob.perform_later(self.id, @mentioned_users.pluck(:id))
  end
end
