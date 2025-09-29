class Practice < ApplicationRecord
  belongs_to :user
  include Taggable
  has_many :practiced_activities

  validates :name, presence: true
  validates :description, presence: true

  after_create :clean_cache!

  private
  def clean_cache!
    Rails.cache.delete("practices:#{user.username}:#{Date.today}")
  end
end
