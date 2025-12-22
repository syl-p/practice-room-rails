class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  scope :for_activities, ->{
    joins(:taggings)
    .where(taggings: { taggable_type: "Activity" })
    .joins("INNER JOIN activities ON activities.id = taggings.taggable_id")
  }

  scope :with_practiced_activities, ->{
    for_activities
      .joins("INNER JOIN practiced_activities ON practiced_activities.id = activities.id")
  }

  scope :with_duration, ->{
    with_practiced_activities
      .select("tags.*, COALESCE(SUM(practiced_activities.duration), 0) as duration")
      .group("tags.id")
  }

  scope :for_practice, ->(practice_id) {
      joins("INNER JOIN practice_activities ON practice_activities.id = activities.id")
      .where(practice_activities: { practice_id: practice_id } )
  }
end
