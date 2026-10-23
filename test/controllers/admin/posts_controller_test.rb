require "test_helper"

module Admin
  class PostsControllerTest < ActionDispatch::IntegrationTest
    test "guests are sent to the login page" do
      get admin_posts_url

      assert_redirected_to new_session_url
    end

    test "members are sent back to the homepage" do
      sign_in(FactoryBot.create(:user))

      get admin_posts_url

      assert_redirected_to root_url
    end

    test "admins list every post, drafts included" do
      sign_in(FactoryBot.create(:user, :admin))
      published = FactoryBot.create(:post, title: "Un article publié")
      draft = FactoryBot.create(:post, :draft, title: "Un brouillon")

      get admin_posts_url

      assert_response :success
      assert_select "a[href=?]", edit_admin_post_path(published)
      assert_select "a[href=?]", edit_admin_post_path(draft)
    end

    test "the list can be filtered by status" do
      sign_in(FactoryBot.create(:user, :admin))
      published = FactoryBot.create(:post)
      draft = FactoryBot.create(:post, :draft)

      get admin_posts_url(status: "draft")

      assert_response :success
      assert_select "a[href=?]", edit_admin_post_path(draft)
      assert_select "a[href=?]", edit_admin_post_path(published), count: 0
    end

    test "the list can be searched by title" do
      sign_in(FactoryBot.create(:user, :admin))
      matching = FactoryBot.create(:post, title: "Pratiquer sans se lasser")
      other = FactoryBot.create(:post, title: "Un tout autre sujet")

      get admin_posts_url(search: "sans se lasser")

      assert_response :success
      assert_select "a[href=?]", edit_admin_post_path(matching)
      assert_select "a[href=?]", edit_admin_post_path(other), count: 0
    end

    test "an admin creates a draft" do
      sign_in(FactoryBot.create(:user, :admin))

      assert_difference -> { Post.count }, 1 do
        post admin_posts_url, params: {
          post: {
            title: "Nouvel article",
            excerpt: "Un extrait",
            content: "<div>Un contenu</div>",
            status: "draft"
          }
        }
      end

      article = Post.last
      assert_redirected_to edit_admin_post_path(article)
      assert_equal "Nouvel article", article.title
      assert_equal "Un extrait", article.excerpt
      assert_predicate article, :draft?
      assert_nil article.published_at
    end

    test "the author of an article is the admin who wrote it" do
      admin = FactoryBot.create(:user, :admin)
      sign_in(admin)

      post admin_posts_url, params: {
        post: { title: "Nouvel article", excerpt: "Un extrait", content: "<div>Un contenu</div>", status: "draft" }
      }

      assert_equal admin, Post.last.user
    end

    test "an admin publishes an article" do
      sign_in(FactoryBot.create(:user, :admin))
      article = FactoryBot.create(:post, :draft)

      patch publish_admin_post_url(article)

      assert_redirected_to admin_posts_url
      assert_predicate article.reload, :published?
      assert_not_nil article.published_at
    end

    test "an admin unpublishes an article" do
      sign_in(FactoryBot.create(:user, :admin))
      article = FactoryBot.create(:post)

      patch unpublish_admin_post_url(article)

      assert_redirected_to admin_posts_url
      assert_predicate article.reload, :draft?
      assert_nil article.published_at
    end

    test "an admin edits an article" do
      sign_in(FactoryBot.create(:user, :admin))
      article = FactoryBot.create(:post, title: "Avant")

      patch admin_post_url(article), params: { post: { title: "Après" } }

      assert_redirected_to edit_admin_post_path(article)
      assert_equal "Après", article.reload.title
    end

    test "an admin deletes an article" do
      sign_in(FactoryBot.create(:user, :admin))
      article = FactoryBot.create(:post)

      assert_difference -> { Post.count }, -1 do
        delete admin_post_url(article)
      end

      assert_redirected_to admin_posts_url
    end

    test "members cannot publish an article" do
      sign_in(FactoryBot.create(:user))
      article = FactoryBot.create(:post, :draft)

      patch publish_admin_post_url(article)

      assert_redirected_to root_url
      assert_predicate article.reload, :draft?
    end

    test "members cannot delete an article" do
      sign_in(FactoryBot.create(:user))
      article = FactoryBot.create(:post)

      assert_no_difference -> { Post.count } do
        delete admin_post_url(article)
      end

      assert_redirected_to root_url
    end

    test "the cover can be uploaded" do
      sign_in(FactoryBot.create(:user, :admin))

      post admin_posts_url, params: {
        post: {
          title: "Avec une image",
          excerpt: "Un extrait",
          content: "<div>Un contenu</div>",
          status: "draft",
          cover: Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/avatar.png"), "image/png")
        }
      }

      assert_predicate Post.last, :cover_attached?
    end

    test "the slug follows the title while the article is a draft" do
      sign_in(FactoryBot.create(:user, :admin))
      article = FactoryBot.create(:post, :draft, title: "Un premier titre")

      patch admin_post_url(article), params: { post: { title: "Un autre titre" } }

      assert_equal "un-autre-titre", article.reload.slug
    end

    test "the slug is frozen once the article is published" do
      sign_in(FactoryBot.create(:user, :admin))
      article = FactoryBot.create(:post, title: "Un premier titre")

      patch admin_post_url(article), params: { post: { title: "Un autre titre" } }

      assert_equal "un-premier-titre", article.reload.slug
    end

    test "an invalid article is rendered back with its errors" do
      sign_in(FactoryBot.create(:user, :admin))

      assert_no_difference -> { Post.count } do
        post admin_posts_url, params: { post: { title: "", excerpt: "", content: "<div>Un contenu</div>", status: "draft" } }
      end

      assert_response :unprocessable_entity
      assert_select "p", text: /2 erreurs/
    end

    test "the form renders the trix editor and the status selector" do
      sign_in(FactoryBot.create(:user, :admin))

      get new_admin_post_url

      assert_response :success
      assert_select "trix-editor"
      assert_select "select[name=?]", "post[status]"
    end
  end
end
