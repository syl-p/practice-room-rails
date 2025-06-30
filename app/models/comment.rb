class Comment < ApplicationRecord
  validates :content, presence: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  # Associations
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  belongs_to :commentable, polymorphic: true

  after_create :notify_user

  private
  def notify_user
    Notification.create(
      user: commentable.user,
      notifiable: self
    )
  end
end
