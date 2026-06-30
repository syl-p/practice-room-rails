require "test_helper"

class PracticeActivities::GoalsControllerTest < ActionDispatch::IntegrationTest
  test "after create redirect to show method" do
    @practice = FactoryBot.create(:practice)
    @activity = FactoryBot.create(:activity)
    @practice_activity = PracticeActivity.create!(practice: @practice, activity: @activity)

    sign_in(@practice.user)
    assert_difference "Goal.count", 1 do
      post practice_activity_goals_path(practice_activity_id: @practice_activity.id), params: {
        goal: {
          target_value: 50,
          unit: "bpm"
        }
      }
    end

    last_goal = @practice_activity.goals.last
    assert_redirected_to goal_path(id: last_goal&.id)
  end
end
