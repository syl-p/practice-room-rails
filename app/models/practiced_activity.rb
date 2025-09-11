class PracticedActivity < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  belongs_to :practice

  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :today, -> { where("created_at >= ?", Date.today) }
  scope :at, ->(start_at, end_at) { where(created_at: start_at..end_at) }

  after_commit :clean_cache

  private
  def clean_cache
    Rails.cache.delete("practice_time_today:#{user.username}:#{Date.today}")
  end
end