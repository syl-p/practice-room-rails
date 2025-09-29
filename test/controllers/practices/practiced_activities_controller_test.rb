require "test_helper"

class PracticedActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated cannot save a practiced_activity" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    post practice_practiced_activities_path(practice_id: practice.id), params: {
      activity_id: activity.id,
      duration: 30
    }
    assert_response :redirect
  end

  test "authenticated user can save a practiced_activity" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_difference "PracticedActivity.count", 1 do
      post practice_practiced_activities_path(practice_id: practice.id), params: {
        activity_id: activity.id,
        duration: 30
      }, as: :turbo_stream
    end

    assert_response :success
  end

  test "fails to create practiced_activity without duration" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_no_difference("PracticedActivity.count") do
      post practice_practiced_activities_path(practice_id: practice.id), params: {
        activity_id: activity.id,
        duration: nil
      }, as: :turbo_stream
    end

    assert_equal "Duration not valid.", flash[:alert]
  end

  test "user cannot provide a invalid duration" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_no_difference("PracticedActivity.count") do
      post practice_practiced_activities_path(practice_id: practice.id), params: {
        activity_id: activity.id,
        duration: "not valid !"
      }, as: :turbo_stream
    end

    assert_equal "Duration not valid.", flash[:alert]
  end

  test "unauthenticated cannot destroy a practiced_activity" do
    practiced_activity = FactoryBot.create(:practiced_activity)
    delete practice_practiced_activity_path(practiced_activity, practice_id: practiced_activity.practice.id)
    assert_response :redirect
  end

  test "authenticated user can destroy is own practiced_activity" do
    practice = FactoryBot.create(:practice)
    practiced_activity = FactoryBot.create(:practiced_activity, user: practice.user, practice: practice)
    sign_in(practice.user)

    assert_difference "PracticedActivity.count", -1 do
      delete practice_practiced_activity_path(practiced_activity, practice_id: practice.id), as: :turbo_stream
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
      delete practice_practiced_activity_path(practiced_activity, practice_id: practiced_activity.id), as: :turbo_stream
    end
    assert_response :not_found
  end
end
