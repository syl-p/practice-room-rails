class CleanNotificationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Notification
      .where("created_at <= ?", 3.minutes.ago)
      .destroy_all
  end
end
