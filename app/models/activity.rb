class Activity < ApplicationRecord
  include Sluggable
  slug_from :title
  include Taggable

  enum :status, [ :draft, :published ], default: :published
  scope :published, -> { where(status: :published) }

  belongs_to :user
  has_many :comments, as: :commentable
  has_many :commenters, -> { distinct }, through: :comments, source: :user
  has_many :practice_entries, dependent: :destroy
  has_and_belongs_to_many :media

  validates :title, presence: true
  validates :content, presence: true
end
