class Goal < ApplicationRecord
  belongs_to :practice_activity
  belongs_to :user
  has_many :progresses, class_name: "GoalProgress", dependent: :destroy
  after_touch :clear_cached_progresses

  validates :target_value, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
  normalizes :unit, with: ->(unit) { unit.strip.capitalize }

  def last_progress
    cached_progresses.first
  end

  def progress_pourcent
    return 0 if target_value.zero?
    return 0 if last_progress.nil?

    ((last_progress.value / target_value) * 100).round.clamp(0, 100)
  end

  def cached_progresses
    Rails.cache.fetch([ self, "progresses" ], expires_in: 1.hour) do
      progresses.order(created_at: :desc)
    end
  end

  def clear_cached_progresses
    Rails.cache.delete([ self, "progresses" ])
  end
end
