require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test "creates a comment notification linked to a comment" do
    notification = FactoryBot.create(:notification, :comment)

    assert_equal "comment", notification.notification_type
    assert_instance_of Comment, notification.notifiable
  end

  test "creates a mention notification linked to a comment" do
    notification = FactoryBot.create(:notification, :mention)

    assert_equal "mention", notification.notification_type
    assert_instance_of Comment, notification.notifiable
  end

  test "delete notifiable also delete notification" do
    notification = FactoryBot.create(:notification, :comment)
    notifiable = notification.notifiable

    assert_difference "Notification.count", -1 do
      notifiable.destroy
    end
  end
end
