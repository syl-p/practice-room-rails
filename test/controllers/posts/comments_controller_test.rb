require "test_helper"

class Posts::CommentsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "unauthenticated visitors cannot comment" do
    post = FactoryBot.create(:post)

    post post_comments_url(post_id: post.slug), params: { comment: { content: "Très clair, merci." } }

    assert_response :redirect
    assert_equal 0, post.reload.comments.count
  end

  test "a member can comment with turbo streams" do
    sign_in(FactoryBot.create(:user))
    post = FactoryBot.create(:post)

    post post_comments_url(post_id: post.slug),
         params: { comment: { content: "Très clair, merci." } },
         as: :turbo_stream

    assert_response :success
    assert_equal 1, post.reload.comments.count
  end

  test "a member can answer a comment on a post" do
    sign_in(FactoryBot.create(:user))
    post = FactoryBot.create(:post)
    root = FactoryBot.create(:comment, commentable: post)

    # Les réponses passent par le contrôleur imbriqué, qui retrouve le
    # commentable via le commentaire parent
    post comment_comments_url(comment_id: root.id),
         params: { comment: { content: "Je plussoie." } },
         as: :turbo_stream

    assert_response :success
    assert_equal 1, root.reload.replies.count
    assert_equal post, root.replies.first.commentable
  end

  test "an empty comment is rejected" do
    sign_in(FactoryBot.create(:user))
    post = FactoryBot.create(:post)

    post post_comments_url(post_id: post.slug),
         params: { comment: { content: "" } },
         as: :turbo_stream

    assert_equal 0, post.reload.comments.count
  end

  test "commenting on a draft post is refused for other members" do
    sign_in(FactoryBot.create(:user))
    draft = FactoryBot.create(:post, :draft)

    post post_comments_url(post_id: draft.slug), params: { comment: { content: "Coulé." } }

    assert_response :redirect
    assert_equal 0, draft.reload.comments.count
  end

  test "commenting notifies the author of the post" do
    author = FactoryBot.create(:user)
    sign_in(FactoryBot.create(:user))
    post = FactoryBot.create(:post, user: author)

    perform_enqueued_jobs do
      post post_comments_url(post_id: post.slug),
           params: { comment: { content: "Merci pour l'article." } },
           as: :turbo_stream
    end

    notification = Notification.order(:created_at).last
    assert_equal author, notification.user
    assert_equal post.comments.last, notification.notifiable
    assert notification.comment?
  end
end
