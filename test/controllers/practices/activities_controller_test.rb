require "test_helper"

class Practices::ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "user_a cannot attach a activity to user_b's practice" do
    # TODO: Check Fail for authorizing
  end

  test "attach a activity to practice" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity, :public)
    sign_in(practice.user)

    post practice_attach_activities_path(practice_id: practice.id, id: activity.id)
    assert_response :success
    assert_includes practice.activities, activity
  end
end
