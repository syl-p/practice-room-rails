class Goal < ApplicationRecord
  belongs_to :practice_activity
  belongs_to :user
  has_many :progresses, class_name: "GoalProgress", dependent: :destroy
  after_touch :clear_cached_progresses

  validates :target_value, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true

  def cached_progresses
    Rails.cache.fetch([ self, "progresses" ], expires_in: 1.hour) do
      progresses.order(created_at: :desc)
    end
  end

  def clear_cached_progresses
    Rails.cache.delete([ self, "progresses" ])
  end
end
