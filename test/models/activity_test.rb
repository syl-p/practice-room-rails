require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  test "should have a valid factory" do
    activity = FactoryBot.build(:activity)
    assert activity.valid?
  end
end
