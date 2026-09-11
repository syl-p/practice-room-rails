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

  # Activity media step
  test "media step redirects to the summary step" do
    activity = FactoryBot.create(:activity, user: @user)

    patch onboarding_activity_step_path({ activity_id: activity.id, step: "media" }), params: {
      onboarding_activity_media_step: { medium_ids: [] }
    }

    assert_redirected_to onboarding_activity_step_path({ activity_id: activity.id, step: "summary" })
  end

  # Activity summary step
  test "show the summary step" do
    activity = FactoryBot.create(:activity, user: @user)

    get onboarding_activity_step_path({ activity_id: activity.id, step: "summary" })
    assert_response :success
  end

  test "summary step can be navigated back to the media step" do
    activity = FactoryBot.create(:activity, user: @user)

    get onboarding_activity_step_path({ activity_id: activity.id, step: "summary" })

    assert_select "a[href=?]", onboarding_activity_step_path({ activity_id: activity.id, step: "media" }), text: "Précédent"
  end

  test "summary step shows the step navigation including itself" do
    activity = FactoryBot.create(:activity, user: @user)

    get onboarding_activity_step_path({ activity_id: activity.id, step: "summary" })

    assert_select "nav[aria-label='Étapes de création'] a[href=?]",
                  onboarding_activity_step_path({ activity_id: activity.id, step: "summary" })
  end

  # Authorization
  test "Could not edit an another user's activity edit" do
    another_user = FactoryBot.create(:user)
    activity = FactoryBot.create(:activity, user: another_user)

    get onboarding_activity_step_path({ activity_id: activity.id, step: "content" })
    assert_response :not_found

    patch onboarding_activity_step_path({ activity_id: activity.id, step: "status" }), params: {
      onboarding_activity_status_step: {
        status: "published"
      }
    }
    assert_response :not_found
  end
end
