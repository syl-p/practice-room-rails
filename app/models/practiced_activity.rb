class PracticedActivity < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  scope :today, -> { where("created_at >= ?", Date.today) }
  scope :at, ->(start_at, end_at) { where("created_at >= ? AND created_at < ?", start_at, end_at) }
end
