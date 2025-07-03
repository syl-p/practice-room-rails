class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  enum :notification_type, [:comment, :mention], default: :comment

  scope :unread , -> {where(read_at: nil).order(read_at: :desc)}

  # websocket
  broadcasts_to ->(record) { "notifications:#{record.user_id}" }, inserts_by: :prepend

  def mark_as_read!
    update(read_at: Time.current)
  end
end
