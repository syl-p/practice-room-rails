require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "should have a valid factory" do
    comment = FactoryBot.create(:comment)
    assert comment.valid?
  end

  test "should associate comment to a commentable model" do
    comment = FactoryBot.create(:comment)
    activity = FactoryBot.create(:activity)

    activity.comments << comment
    assert_includes activity.comments, comment
    assert_equal comment.commentable, activity
  end

  test "reply should be valid" do
    parent_comment = FactoryBot.create(:comment)
    reply = FactoryBot.create(:comment, parent_id: parent_comment.id)

    assert reply.valid?
    assert_includes parent_comment.replies, reply
    assert_equal reply.parent_id, parent_comment.id
  end
end
