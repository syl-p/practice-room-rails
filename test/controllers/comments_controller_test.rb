require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated cannot post comments" do
    activity = FactoryBot.create(:activity, :public)
    post activity_comments_url(activity_id: activity.id), params: { comment: { content: "This is a test comment." } }
    assert_response :redirect
  end

  test "authenticated user can post a comment with turbo" do
    user = FactoryBot.create(:user, password: "password")
    sign_in(user)

    activity = FactoryBot.create(:activity, :public)
    post activity_comments_url(activity_id: activity.id), params: { comment: { content: "This is a test comment." } }, as: :turbo_stream
    assert_response :success
  end

  test "le HTML d'un commentaire est neutralisé" do
    comment = FactoryBot.create(:comment, content: %q{<script>alert("xss")</script>})

    get comment_url(comment)

    assert_response :success
    assert_select "article.comment script", count: 0
  end

  test "un lien javascript est rendu comme du texte" do
    comment = FactoryBot.create(:comment, content: %q{<a href="javascript:alert(1)">clic</a>})

    get comment_url(comment)

    assert_select "article.comment a[href^='javascript']", count: 0
  end

  test "les mentions sont rendues comme des liens" do
    user = FactoryBot.create(:user, username: "bob")
    comment = FactoryBot.create(:comment, content: "Salut @bob")

    get comment_url(comment)

    assert_select "article.comment a[href=?]", user_path(user), text: "@bob"
  end
end
