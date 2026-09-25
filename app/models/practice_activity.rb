class PracticeActivity < ApplicationRecord
  belongs_to :activity
  belongs_to :practice
  has_many :goals, dependent: :destroy

  def active_goal
    goals.first
  end
end
