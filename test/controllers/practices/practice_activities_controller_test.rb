require "test_helper"

class Practices::PracticeActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "user_a cannot attach a activity to user_b's practice" do
    # TODO: Check Fail for authorizing
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity, :public)
    sign_in(FactoryBot.create(:user))

    assert_no_difference "PracticeActivity.count" do
      post practice_practice_activities_path(practice_id: practice.id), params: {
        activity_id: activity.id
      }
    end

    assert_redirected_to practice_path(practice)
    assert_not_includes practice.activities, activity
  end

  test "attach a activity to practice" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity, :public)
    sign_in(practice.user)

    assert_difference("PracticeActivity.count", 1) do
      post practice_practice_activities_path(practice_id: practice.id), params: {
        activity_id: activity.id
      }
    end

    assert_redirected_to practice_path(practice)
    assert_includes practice.activities, activity
  end

  test "cannot attach a activity twice to practice" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity, :public)
    sign_in(practice.user)

    assert_difference("PracticeActivity.count", 1) do
      post practice_practice_activities_path(practice_id: practice.id), params: {
        activity_id: activity.id
      }
    end

    assert_redirected_to practice_path(practice)

    assert_no_difference("PracticeActivity.count") do
      post practice_practice_activities_path(practice_id: practice.id), params: {
        activity_id: activity.id
      }
    end

    assert_redirected_to practice_path(practice)
  end
end
