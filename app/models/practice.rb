class Practice < ApplicationRecord
  belongs_to :user, touch: true
  include Taggable
  has_many :practiced_activities

  validates :name, presence: true
  validates :description, presence: true
end
