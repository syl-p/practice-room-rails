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
  has_rich_text :content


  validates :title, presence: true
  validate :validate_content_presence

  def validate_content_presence
    errors.add(:content, "doit être rempli(e)") if content.to_plain_text.blank?
  end
end
