require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "get practice_entries duration by tags" do
    practice = FactoryBot.create(:practice)
    tag = FactoryBot.create(:tag)
    activity = FactoryBot.create(:activity)
    user = FactoryBot.create(:user)
    activity.tags << tag

    practice.tags << tag
    practice.activities << activity

    PracticeEntry.create(practice:, activity:, user:, duration: 5)
    PracticeEntry.create(practice:, activity:, user:, duration: 10)

    tags_by_duration = Tag.for_practice_with_duration(practice.id)

    assert_not_empty tags_by_duration
    assert tags_by_duration.first&.duration, 15
  end
end
