require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  def sign_in(user)
    post session_url, params: { email_address: user.email_address, password: "password" }
    assert_response :redirect
  end

  test "should get index" do
    get activities_url
    assert_response :success
  end

  test "should have show action" do
    activity = FactoryBot.create(:activity)

    get activity_url(activity)
    assert_response :success
  end

  test "draft activities are not visible to unauthenticated users" do
    activity = FactoryBot.create(:activity, :draft)

    get activity_url(activity)
    assert_response :redirect
    assert_redirected_to activities_url
  end

  test "draft activities are visible to authenticated users" do
    user = FactoryBot.create(:user)
    activity = FactoryBot.build(:activity, :draft)
    activity.user = user
    activity.save!

    sign_in(user)

    get activity_url(activity)
    assert_response :success
  end
end
