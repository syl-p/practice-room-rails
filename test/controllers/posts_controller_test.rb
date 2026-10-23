require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated visitors can browse the blog" do
    FactoryBot.create(:post, :with_comments)

    get posts_url

    assert_response :success
  end

  test "index only lists published posts, newest first" do
    older = FactoryBot.create(:post, published_at: 3.days.ago)
    newer = FactoryBot.create(:post, published_at: 1.day.ago)
    draft = FactoryBot.create(:post, :draft)

    get posts_url

    assert_response :success
    assert_select "a[href=?]", post_path(newer)
    assert_select "a[href=?]", post_path(older)
    assert_select "a[href=?]", post_path(draft), count: 0

    # Le plus récent passe à la une, les suivants en carte
    assert_select "h2 a[href=?]", post_path(newer)
    assert_select "h3 a[href=?]", post_path(older)
  end

  test "index renders an empty state when nothing is published" do
    get posts_url

    assert_response :success
    assert_select "h2", text: "Le premier article arrive bientôt"
  end

  test "show is reachable from the slug" do
    post = FactoryBot.create(:post, title: "Pratiquer sans se lasser")

    get post_url(post)

    assert_response :success
    assert_select "h1", text: post.title
  end

  test "show exposes the seo head" do
    post = FactoryBot.create(:post, meta_description: "Une description dédiée au référencement.")

    get post_url(post)

    assert_response :success
    assert_select "title", text: "#{post.title} - Practice Room"
    assert_select "meta[name=description][content=?]", "Une description dédiée au référencement."
    assert_select "meta[property='og:type'][content=article]"
    assert_select "meta[property='article:published_time']"
  end

  test "show publishes a valid BlogPosting schema" do
    post = FactoryBot.create(:post)

    get post_url(post)

    payload = JSON.parse(css_select("script[type='application/ld+json']").first.text)

    assert_equal "https://schema.org", payload["@context"]
    assert_equal "BlogPosting", payload["@type"]
    assert_equal post.title, payload["headline"]
    assert_equal post_url(post), payload["url"]
    assert_equal post.user.username, payload.dig("author", "name")
    assert_equal "Practice Room", payload.dig("publisher", "name")
  end

  test "index publishes a valid Blog schema" do
    FactoryBot.create(:post)

    get posts_url

    payload = JSON.parse(css_select("script[type='application/ld+json']").first.text)

    assert_equal "Blog", payload["@type"]
    assert_equal 1, payload["blogPost"].size
    assert_equal posts_url, payload["url"]
  end

  test "show renders the cover image and the content" do
    post = FactoryBot.create(:post, :with_cover, content: "<div>Un paragraphe bien long.</div>")

    get post_url(post)

    assert_response :success
    assert_select "figure img[alt=?]", post.title
    assert_select ".article-content", text: /Un paragraphe bien long/
  end

  test "the cover becomes the social image, as an absolute url" do
    post = FactoryBot.create(:post, :with_cover)

    get post_url(post)

    image = JSON.parse(css_select("script[type='application/ld+json']").first.text)["image"]
    assert image.start_with?("http"), "l'image de partage doit être absolue, obtenu : #{image.inspect}"
    assert_select "meta[property='og:image'][content=?]", image
  end

  test "guests are invited to sign in to join the discussion" do
    post = FactoryBot.create(:post, :with_comments)

    get post_url(post)

    assert_response :success
    assert_select "h2", text: /3 commentaires/
    assert_select "turbo-frame##{dom_id(post)}_comments"
    assert_select "a[href=?]", new_session_path
    assert_select "form[action=?]", post_comments_path(post), count: 0
  end

  test "members get the comment form" do
    sign_in(FactoryBot.create(:user))
    post = FactoryBot.create(:post)

    get post_url(post)

    assert_response :success
    assert_select "form[action=?]", post_comments_path(post)
  end

  test "draft posts are hidden from unauthenticated visitors" do
    draft = FactoryBot.create(:post, :draft)

    get post_url(draft)

    assert_response :not_found
  end

  test "draft posts are visible to their author" do
    author = FactoryBot.create(:user)
    draft = FactoryBot.create(:post, :draft, user: author)

    sign_in(author)

    get post_url(draft)

    assert_response :success
    assert_select "h1", text: draft.title
  end

  test "draft posts stay hidden from other members" do
    FactoryBot.create(:post, :draft)
    intruder = FactoryBot.create(:user)

    sign_in(intruder)

    get post_url(Post.last)

    assert_response :not_found
  end

  test "unknown slug returns not found" do
    get "/blog/aucun-article"

    assert_response :not_found
  end
end
