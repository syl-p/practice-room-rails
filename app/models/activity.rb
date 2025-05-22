class Activity < ApplicationRecord
  include Sluggable
  slug_from :title

  include Taggable

  belongs_to :user
  validates :title, presence: true
  validates :content, presence: true
end
