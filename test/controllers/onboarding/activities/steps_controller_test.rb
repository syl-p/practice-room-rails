require "test_helper"

class Onboarding::Activities::StepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  # Activity content step
  test "new activity path" do
    get onboarding_activities_new_path
    assert_response :success
  end

  test "submit on the first step (content)" do
    post onboarding_activities_path, params: {
      onboarding_activity_content_step: { title: "Mon titre", content: "Mon contenu" }
    }

    activity = Activity.last
    assert_equal "Mon titre", activity.title
    assert_redirected_to onboarding_activity_step_path(activity, "tags")
  end

  test "edit activity's content" do
    activity = FactoryBot.create(:activity, user: @user)

    get onboarding_activity_step_path({ activity_id: activity.id, step: "content" })
    assert_response :success
  end

  # Activity tags step
  test "go to the tags step" do
    activity = FactoryBot.create(:activity, user: @user)

    get onboarding_activity_step_path({ activity_id: activity.id, step: "content" })
    assert_response :success
  end

  test "send tags labels to update activities" do
    activity = FactoryBot.create(:activity, user: @user)

    patch onboarding_activity_step_path({ activity_id: activity.id, step: "tags" }), params: {
      onboarding_activity_tags_step: {
        labels: "test, test2"
      }
    }

    assert_redirected_to onboarding_activity_step_path({ activity_id: activity.id, step: "status" })
    assert_includes activity.reload.tags.pluck(:name), "Test"
    assert_includes activity.reload.tags.pluck(:name), "Test2"
  end

  # Activity status
  test "got to activity's status step" do
    activity = FactoryBot.create(:activity, user: @user)

    get onboarding_activity_step_path({ activity_id: activity.id, step: "status" })
    assert_response :success
  end

  test "edit activity's status" do
    activity = FactoryBot.create(:activity, user: @user)

    patch onboarding_activity_step_path({ activity_id: activity.id, step: "status" }), params: {
      onboarding_activity_status_step: {
        status: "published"
      }
    }

    assert_redirected_to onboarding_activity_step_path({ activity_id: activity.id, step: "media" })
    assert_equal activity.reload.status, "published"
  end
end
