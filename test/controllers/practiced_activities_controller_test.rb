require "test_helper"

class PracticedActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated cannot save a practiced_activity" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    post practiced_activities_url, params: {
      activity_id: activity.id,
      duration: 30,
      practice_id: practice.id
    }
    assert_response :redirect
  end

  test "authenticated user can save a practiced_activity" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_difference "PracticedActivity.count", 1 do
      post practiced_activities_url, params: {
        activity_id: activity.id,
        duration: 30,
        practice_id: practice.id
      }, as: :turbo_stream
    end

    assert_response :success
  end

  test "fails to create practiced_activity without duration" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_no_difference("PracticedActivity.count") do
      post practiced_activities_url, params: {
        activity_id: activity.id,
        duration: nil,
        practice_id: practice.id
      }, as: :turbo_stream
    end

    assert_equal "Duration not found.", flash[:alert]
  end

  test "fails to create practiced_activity without practice" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_no_difference("PracticedActivity.count") do
      post practiced_activities_url, params: {
        activity_id: activity.id,
        duration: 5000
      }, as: :turbo_stream
    end

    assert_equal "Practice not found.", flash[:alert]
  end

  test "unauthenticated cannot destroy a practiced_activity" do
    practiced_activity = FactoryBot.create(:practiced_activity)
    delete practiced_activity_url(practiced_activity)
    assert_response :redirect
  end

  test "authenticated user can destroy is own practiced_activity" do
    practice = FactoryBot.create(:practice)
    practiced_activity = FactoryBot.create(:practiced_activity, user: practice.user, practice: practice)
    sign_in(practice.user)

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
