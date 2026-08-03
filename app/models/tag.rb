class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  scope :for_practice_with_duration, ->(practice_id) {
    joins("INNER JOIN taggings tp
          ON tp.tag_id = tags.id
          AND tp.taggable_type = 'Practice'")
      .joins("INNER JOIN taggings ta
              ON ta.tag_id = tags.id
              AND ta.taggable_type = 'Activity'")
      .joins("INNER JOIN activities
              ON activities.id = ta.taggable_id")
      .joins("INNER JOIN practice_entries
              ON practice_entries.activity_id = activities.id")
      .where("tp.taggable_id = ?", practice_id)
      .where(practice_entries: { practice_id: practice_id })
      .select("tags.*, SUM(practice_entries.duration) AS duration")
      .group("tags.id")
  }

  before_save :capitalize_name
  def capitalize_name
    self.name = name.capitalize
  end
end
