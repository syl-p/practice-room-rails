require "test_helper"

class PracticeEntryTest < ActiveSupport::TestCase
  test "today scope must return today entity" do
    user = FactoryBot.create(:user)
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    today_activity =  PracticeEntry.create(
      user:,
      activity:,
      practice:,
      duration: 30,
      created_at: Date.today)

    yesterday_activity = PracticeEntry.create(
      user:,
      activity:,
      practice:,
      duration: 30,
      created_at: Date.yesterday)

    assert_includes PracticeEntry.today, today_activity
    assert_not_includes PracticeEntry.today, yesterday_activity
  end

  test "with total duration scope add sum aggregate" do
    FactoryBot.create_list(:practice_entry, 3)
    assert_equal PracticeEntry.with_total_duration, 30
  end
end
