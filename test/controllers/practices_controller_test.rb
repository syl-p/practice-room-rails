require "test_helper"

class PracticesControllerTest < ActionDispatch::IntegrationTest
  test "no signed in user cannot see practice" do
    practice = FactoryBot.create(:practice)
    get practice_path(practice)
    assert_response :redirect
    assert_redirected_to new_session_path
  end

  test "signed in user can see his practice" do
    practice = FactoryBot.create(:practice)
    sign_in practice.user
    get practice_path(practice)
    assert_response :success
  end

  test "other user cannot see another user's practice" do
    practice = FactoryBot.create(:practice)
    sign_in FactoryBot.create(:user)
    get practice_path(practice)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "signed user can edit his practice" do
    practice = FactoryBot.create(:practice)
    sign_in practice.user

    get edit_practice_path(practice)
    assert_response :success
  end
end
