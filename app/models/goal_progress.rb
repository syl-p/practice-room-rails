class GoalProgress < ApplicationRecord
  belongs_to :goal, touch: true
  validates :value, presence: true, numericality: { greater_than: 0 }
end
