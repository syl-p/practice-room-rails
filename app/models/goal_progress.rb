class GoalProgress < ApplicationRecord
  belongs_to :goal, touch: true
  validates :value, presence: true, numericality: { greater_than: 0 }

  validate :check_value_not_exceed_target_value

  def check_value_not_exceed_target_value
    return unless value > goal.target_value

    errors.add(:value, "cannot exceed target value")
  end
end
