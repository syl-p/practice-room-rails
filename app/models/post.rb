class Post < ApplicationRecord
  include Sluggable
  slug_from :title

  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, -> { distinct }, through: :comments, source: :user

  has_rich_text :content
  has_one_attached :cover

  enum :status, [ :draft, :published ], default: :draft
  scope :published, -> { where(status: :published) }
  scope :recent, -> { order(published_at: :desc, created_at: :desc) }

  validates :title, presence: true
  validates :excerpt, presence: true
  validates :meta_description, length: { maximum: 160 }, allow_blank: true

  before_validation :stamp_published_at
  before_validation :refresh_draft_slug, if: :refresh_draft_slug?

  def to_param
    slug
  end

  def cover_attached?
    cover.attached?
  end

  def reading_time
    [ content.to_plain_text.split.size / 200, 1 ].max
  end

  def description
    meta_description.presence || excerpt.to_s.squish.truncate(155)
  end

  private
    def stamp_published_at
      if published?
        self.published_at ||= Time.current
      else
        self.published_at = nil
      end
    end

    # Tant que l'article est un brouillon, son url suit son titre.
    # Une fois publié, le slug reste figé pour ne pas casser les liens.
    def refresh_draft_slug?
      persisted? && draft? && title.present? && slug.present?
    end

    def refresh_draft_slug
      self.slug = nil
      generate_slug
    end
end
