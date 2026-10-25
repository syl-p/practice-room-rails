require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should have a valid factory" do
    post = FactoryBot.create(:post)
    assert post.valid?
  end

  test "title and excerpt are required" do
    post = FactoryBot.build(:post, title: nil, excerpt: nil)

    assert_not post.valid?
    assert_includes post.errors[:title], "doit être rempli(e)"
    assert_includes post.errors[:excerpt], "doit être rempli(e)"
  end

  test "slug is generated from the title and used in the url" do
    post = FactoryBot.create(:post, title: "Comment tenir 30 jours de pratique")

    assert_equal "comment-tenir-30-jours-de-pratique", post.slug
    assert_equal post.slug, post.to_param
  end

  test "slugs are unique" do
    first = FactoryBot.create(:post, title: "Le même titre")
    duplicate = FactoryBot.build(:post, title: "Le même titre")

    assert duplicate.valid?
    assert_not_equal first.slug, duplicate.slug
  end

  test "published_at is stamped when the post goes live" do
    post = FactoryBot.create(:post, status: :draft)
    assert_nil post.published_at

    post.update!(status: :published)
    assert_not_nil post.published_at
  end

  test "published scope only returns live posts" do
    live = FactoryBot.create(:post)
    FactoryBot.create(:post, :draft)

    assert_equal [ live ], Post.published.to_a
  end

  test "recent scope returns the newest posts first" do
    older = FactoryBot.create(:post, published_at: 3.days.ago)
    newer = FactoryBot.create(:post, published_at: 1.day.ago)

    assert_equal [ newer, older ], Post.published.recent.to_a
  end

  test "description falls back on the excerpt" do
    post = FactoryBot.build(:post, meta_description: nil)

    assert_equal post.excerpt, post.description
  end

  test "description uses the meta description when present" do
    post = FactoryBot.build(:post, meta_description: "Une description courte.")

    assert_equal "Une description courte.", post.description
  end

  test "meta description is capped at 160 characters" do
    post = FactoryBot.build(:post, meta_description: "a" * 161)

    assert_not post.valid?
    assert_includes post.errors[:meta_description], "est trop long (pas plus de 160 caractères)"
  end

  test "reading time is at least one minute" do
    assert_equal 1, FactoryBot.build(:post).reading_time
    assert_operator FactoryBot.build(:post, content: "<div>#{"mot " * 600}</div>").reading_time, :>=, 3
  end

  test "posts are commentable" do
    post = FactoryBot.create(:post)
    comment = FactoryBot.create(:comment, commentable: post, user: FactoryBot.create(:user))

    assert_includes post.comments, comment
    assert_equal comment, post.comments.first
  end

  test "top_level scope only returns root comments" do
    post = FactoryBot.create(:post)
    root = FactoryBot.create(:comment, commentable: post)
    FactoryBot.create(:comment, commentable: post, parent: root)

    assert_equal [ root ], post.comments.top_level.to_a
  end
end
