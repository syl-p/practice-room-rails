require "test_helper"

module Admin
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test "guests are sent to the login page" do
      get admin_root_url

      assert_redirected_to new_session_url
    end

    test "members are sent back to the homepage" do
      sign_in(FactoryBot.create(:user))

      get admin_root_url

      assert_redirected_to root_url
    end

    test "admins reach the dashboard" do
      sign_in(FactoryBot.create(:user, :admin))

      get admin_root_url

      assert_response :success
      assert_select "h1", text: "Tableau de bord"
    end

    test "the dashboard counts the community" do
      user = FactoryBot.create(:user, :admin)
      FactoryBot.create(:practice, user: user)
      FactoryBot.create(:activity, user: user)
      FactoryBot.create(:comment, user: user)

      sign_in(user)

      get admin_root_url

      assert_response :success
      assert_select "p", text: User.count.to_s
      assert_select "p", text: Practice.count.to_s
      assert_select "p", text: Activity.count.to_s
      assert_select "p", text: Comment.count.to_s
    end

    test "the dashboard counts the published and draft posts" do
      FactoryBot.create(:post)
      FactoryBot.create(:post, :draft)

      sign_in(FactoryBot.create(:user, :admin))

      get admin_root_url

      assert_response :success
      assert_select "p", text: "1", count: 2
      assert_select "span", text: "Publié"
      assert_select "span", text: "Brouillon"
    end

    test "the dashboard lists the latest posts" do
      post = FactoryBot.create(:post, title: "Pratiquer sans se lasser")

      sign_in(FactoryBot.create(:user, :admin))

      get admin_root_url

      assert_response :success
      assert_select "p", text: "Pratiquer sans se lasser"
      assert_select "p", text: /#{Regexp.escape(post.user.username)}/
    end
  end
end
