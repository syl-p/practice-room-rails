class PracticedActivity < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :today, -> { where("created_at >= ?", Date.today) }
  scope :at, ->(start_at, end_at) { where("created_at >= ? AND created_at < ?", start_at, end_at) }
end
