require "test_helper"

class RegistrationControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "create new user, redirect to new practice" do
    post registration_path(params: {
      user: {
        username: "test",
        email_address: "test@test.test",
        password: "password",
        password_confirmation: "password"
      }
    })

    assert_redirected_to root_path
  end
end
