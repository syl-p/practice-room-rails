class CleanNotificationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Notification
      .where("read_at IS NOT NULL")
      .destroy_all
  end
end
