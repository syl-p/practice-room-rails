require "test_helper"

class GoalTest < ActiveSupport::TestCase
  test "target value must be present" do
    goal = Goal.new
    assert_not goal.valid?
    assert goal.errors[:target_value].any?
  end

  test "unit value must be present" do
    goal = Goal.new
    assert_not goal.valid?
    assert goal.errors[:unit].any?
  end

  test "unit must be capitalized" do
  end
end
