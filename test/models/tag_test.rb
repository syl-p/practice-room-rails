require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "get practiced_activities duration by tags" do
    practice = FactoryBot.create(:practice)
    tag = FactoryBot.create(:tag)
    activity = FactoryBot.create(:activity)
    user = FactoryBot.create(:user)
    activity.tags << tag
    practice.activities << activity

    PracticedActivity.create(practice:, activity:, user:, duration: 5)
    PracticedActivity.create(practice:, activity:, user:, duration: 10)
    tags_by_duration = Tag.with_duration

    assert_not_empty tags_by_duration
    assert tags_by_duration.first&.duration, 15
  end
end
