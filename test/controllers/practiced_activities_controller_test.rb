require "test_helper"

class PracticedActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated cannot save a practiced_activity" do
    activity = FactoryBot.create(:activity)
    post practiced_activities_url, params: { activity_id: activity.id, duration: 30 }
    assert_response :redirect
  end

  test "authenticated user can save a practiced_activity" do
    user = FactoryBot.create(:user)
    activity = FactoryBot.create(:activity)
    sign_in(user)

    assert_difference "PracticedActivity.count", 1 do
      post practiced_activities_url, params: { activity_id: activity.id, duration: 30 }, as: :turbo_stream
    end

    assert_response :success
  end

  test "fails to create practiced_activity without duration" do
    user = FactoryBot.create(:user)
    activity = FactoryBot.create(:activity)
    sign_in(user)

    assert_no_difference("PracticedActivity.count") do
      post practiced_activities_url, params: { activity_id: activity.id, duration: nil }, as: :turbo_stream
    end

    assert_redirected_to dashboard_path
    assert_equal "Failed to practice activity.", flash[:alert]
  end

  test "unauthenticated cannot destroy a practiced_activity" do
    practiced_activity = FactoryBot.create(:practiced_activity)
    delete practiced_activity_url(practiced_activity)
    assert_response :redirect
  end

  test "authenticated user can destroy is own practiced_activity" do
    user = FactoryBot.create(:user)
    practiced_activity = FactoryBot.create(:practiced_activity, user: user)
    sign_in(user)
    assert_difference "PracticedActivity.count", -1 do
      delete practiced_activity_url(practiced_activity), as: :turbo_stream
    end
    assert_response :success
  end

  test "authenticated user cannot destroy another user's practiced_activity" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    practiced_activity = FactoryBot.build(:practiced_activity, user: user2)
    practiced_activity.save
    sign_in(user1)
    assert_no_difference "PracticedActivity.count" do
      delete practiced_activity_url(practiced_activity), as: :turbo_stream
    end
    assert_response :not_found
  end
end
