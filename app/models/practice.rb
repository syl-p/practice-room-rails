class Practice < ApplicationRecord
  belongs_to :user
  include Taggable

  after_create :invalidate_cache!

  private
  def invalidate_cache!
    Rails.cache.delete("practices:#{user.username}")
  end
end
