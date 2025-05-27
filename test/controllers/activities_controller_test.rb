require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get activities_url
    assert_response :success
  end

  test "should have show action" do
    activity = FactoryBot.create(:activity)

    get activity_url(activity)
    assert_response :success
  end
end
