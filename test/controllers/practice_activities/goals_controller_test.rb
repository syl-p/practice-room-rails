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
    assert_equal @practice.user, last_goal.user
  end

  test "should propose to create a goal when the practice activity has none" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    practice_activity = FactoryBot.create(:practice_activity, practice: practice, activity: activity)

    sign_in(practice.user)
    get practice_activity_path(practice, activity)

    assert_response :success
    assert_select "turbo-frame#goal_sidebar[src=?]",
                  new_practice_activity_goal_path(practice_activity_id: practice_activity.id)
  end

  test "should ignore a goal owned by another user on the activity show page" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity, :public)
    practice_activity = FactoryBot.create(:practice_activity, practice: practice, activity: activity)

    other_user = FactoryBot.create(:user)
    foreign_goal = FactoryBot.create(
      :goal,
      practice_activity: practice_activity,
      user: other_user
    )

    sign_in(practice.user)

    get practice_activity_path(practice, activity)

    assert_response :success

    # goal form must be present
    assert_select "turbo-frame#goal_sidebar[src=?]",
                  new_practice_activity_goal_path(practice_activity_id: practice_activity.id)

    # ...but another's goal must be ignored.
    assert_select "turbo-frame#goal_sidebar[src=?]",
                  goal_path(foreign_goal),
                  count: 0
  end

  test "[Authorization] should not create a goal on another user's practice activity" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    practice_activity = FactoryBot.create(:practice_activity, practice: practice, activity: activity)

    intruder = FactoryBot.create(:user)
    sign_in(intruder)

    assert_no_difference "Goal.count" do
      post practice_activity_goals_path(practice_activity_id: practice_activity.id), params: {
        goal: {
          target_value: 50,
          unit: "bpm"
        }
      }
    end

    assert_redirected_to root_path
  end
end
