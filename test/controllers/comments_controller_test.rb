require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated cannot post comments" do
    activity = FactoryBot.create(:activity, :public)
    post activity_comments_url(activity_id: activity.id), params: { comment: { content: "This is a test comment." } }
    assert_response :redirect
  end

  test "authenticated user can post a comment" do
    user = FactoryBot.create(:user, password: "password")
    sign_in(user)

    activity = FactoryBot.create(:activity, :public)
    post activity_comments_url(activity_id: activity.id), params: { comment: { content: "This is a test comment." } }
    assert_response :success
  end
end
