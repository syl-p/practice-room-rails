require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "should have a valid factory" do
    comment = FactoryBot.create(:comment)
    assert comment.valid?
  end

  test "comment should have content" do
    comment = FactoryBot.build(:comment, content: nil)
    assert_not comment.valid?
    assert_includes comment.errors[:content], "doit être rempli(e)"
  end

  test "should associate comment to a commentable model" do
    comment = FactoryBot.create(:comment)
    activity = FactoryBot.create(:activity)

    activity.comments << comment
    assert_includes activity.comments, comment
    assert_equal comment.commentable, activity
  end

  test "reply should be valid" do
    commentable = FactoryBot.create(:activity)
    parent_comment = FactoryBot.build(:comment)
    parent_comment.commentable = commentable
    parent_comment.save!


    reply = Comment.new(content: "This is a reply", commentable:, parent_id: parent_comment.id)

    parent_comment.replies << reply

    assert_includes parent_comment.replies, reply
    assert_equal reply.parent_id, parent_comment.id
    assert_equal reply.commentable, commentable
  end
end
