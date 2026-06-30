class Practice < ApplicationRecord
  include Taggable

  belongs_to :user, touch: true
  has_many :practice_entries
  has_many :today_entries, -> { today }, class_name: "PracticeEntry"

  has_many :practice_activities
  has_many :activities, through: :practice_activities

  validates :name, presence: true
  validates :description, presence: true
end
