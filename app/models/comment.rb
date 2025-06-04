class Comment < ApplicationRecord
  validates :content, presence: true

  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  # Associations
  belongs_to :user
  belongs_to :commentable, polymorphic: true
end
