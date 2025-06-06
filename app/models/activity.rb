class Activity < ApplicationRecord
  include Sluggable
  slug_from :title
  include Taggable
  enum :status, [ :draft, :published ], default: :published

  belongs_to :user
  has_many :comments, as: :commentable
  has_many :commenters, -> { distinct }, through: :comments, source: :user

  validates :title, presence: true
  validates :content, presence: true
end
