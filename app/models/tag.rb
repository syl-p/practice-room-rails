class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  scope :for_activities, ->{
    joins(:taggings)
    .where(taggings: { taggable_type: "Activity" })
    .joins("INNER JOIN activities ON activities.id = taggings.taggable_id")
  }

  scope :with_practice_entries, ->{
    for_activities
      .joins("INNER JOIN practice_entries ON practice_entries.id = activities.id")
  }

  scope :with_duration, ->{
    with_practice_entries
      .select("tags.*, COALESCE(SUM(practice_entries.duration), 0) as duration")
      .group("tags.id")
  }

  scope :for_practice, ->(practice_id) {
      joins("INNER JOIN practice_activities ON practice_activities.id = activities.id")
      .where(practice_activities: { practice_id: practice_id } )
  }
end
