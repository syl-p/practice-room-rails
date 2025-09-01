class NotificationsController < ApplicationController
  def index
    @notifications = Current.user.notifications.order(created_at: :desc).limit(5)
    @notifications.unread.update_all(read_at: DateTime.now)
  end
end
