require "test_helper"

class PracticeActivityTest < ActiveSupport::TestCase
  test "activity can be attach to a practice once time only" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)

    assert_difference "PracticeActivity.count", 1 do
      practice.activities << activity
    end

    assert_raise(Exception) { practice.activities << activity }
  end

  test "when we delete a practice_activity, goal and goal_progress must be clear" do
    practice_activity = FactoryBot.create(:practice_activity)

    goal = FactoryBot.create(:goal, practice_activity: practice_activity)
    FactoryBot.create_list(:goal_progress, 3, goal: goal)

    assert_difference "PracticeActivity.count", -1 do
      assert_difference "Goal.count", -1 do
        assert_difference "GoalProgress.count", -3 do
          practice_activity.destroy
        end
      end
    end
  end
end
