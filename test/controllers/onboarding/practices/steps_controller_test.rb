require "test_helper"

class Onboarding::Practices::StepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  # Practice content step
  test "new practice path" do
    get onboarding_practices_new_path
    assert_response :success
  end

  test "submit on the first step (content)" do
    post onboarding_practices_path, params: {
      onboarding_practice_content_step: { name: "Mon instrument", description: "Ma description" }
    }

    practice = Practice.last
    assert_equal "Mon instrument", practice.name
    assert_redirected_to onboarding_practice_step_path(practice, "tags")
  end

  test "edit practice's content" do
    practice = FactoryBot.create(:practice, user: @user)

    get onboarding_practice_step_path(practice, "content")
    assert_response :success
  end

  # Practice tags step
  test "go to the tags step" do
    practice = FactoryBot.create(:practice, user: @user)

    get onboarding_practice_step_path(practice, "tags")
    assert_response :success
  end

  test "send tags labels to update practice" do
    practice = FactoryBot.create(:practice, user: @user)

    patch onboarding_practice_step_path(practice, "tags"), params: {
      onboarding_practice_tags_step: {
        labels: "test, test2"
      }
    }

    assert_includes practice.reload.tags.pluck(:name), "Test"
    assert_includes practice.reload.tags.pluck(:name), "Test2"
  end

  test "completes the onboarding after the last step" do
    practice = FactoryBot.create(:practice, user: @user)

    patch onboarding_practice_step_path(practice, "tags"), params: {
      onboarding_practice_tags_step: {
        labels: "test"
      }
    }

    assert_response :success
    assert_includes response.body, "turbo-stream"
  end
end
