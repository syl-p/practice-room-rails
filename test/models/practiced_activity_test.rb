require "test_helper"

class PracticedActivityTest < ActiveSupport::TestCase
  test "today scope must return today entity" do
    user = FactoryBot.create(:user)
    activity = FactoryBot.create(:activity)
    today_activity =  PracticedActivity.create(user: user, activity: activity, duration: 30, created_at: Date.today)
    yesterday_activity = PracticedActivity.create(user: user, activity: activity, duration: 30, created_at: Date.yesterday)

    assert_includes PracticedActivity.today, today_activity
    assert_not_includes PracticedActivity.today, yesterday_activity
  end
end
