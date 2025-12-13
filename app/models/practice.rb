class Practice < ApplicationRecord
  include Taggable

  belongs_to :user, touch: true
  has_many :practiced_activities
  has_many :practice_activities
  has_many :activities, through: :practice_activities

  validates :name, presence: true
  validates :description, presence: true
end
