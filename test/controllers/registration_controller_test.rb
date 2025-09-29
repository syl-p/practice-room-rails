require "test_helper"

class RegistrationControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "create new user and sign in" do
    post registration_path(params: {
      user: {
        username: "test",
        email: "test@test.test"
      }
    })

    assert_response :success
  end
end
