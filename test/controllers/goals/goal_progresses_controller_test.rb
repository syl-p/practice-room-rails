require "test_helper"

class Goals::GoalProgressesControllerTest < ActionDispatch::IntegrationTest
	test "one goal progress by day" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)
    practice_activity = PracticeActivity.new(practice: practice, activity: activity)
    practice_activity.save!

    goal = FactoryBot.create(:goal, practice_activity: practice_activity)

    assert_difference("GoalProgress.count") do
      post goal_goal_progresses_path(goal_id: goal.id), params: {
        goal_progress: {
          value: 30
        }
      }, as: :turbo_stream
    end

    assert_response :success

    # Already created today
    assert_no_difference("GoalProgress.count") do
      post goal_goal_progresses_path(goal_id: goal.id), params: {
        goal_progress: {
          value: 50
        }
      }, as: :turbo_stream
    end

    assert_response :success
  end
end
