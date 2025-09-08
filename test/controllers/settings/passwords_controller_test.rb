require "test_helper"

class Settings::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "Password Challenge must not be blank" do
    user = FactoryBot.create(:user)
    sign_in(user)

    put settings_password_path, params: { user: { password: "password", password_confirmation: "password" } }
    assert_response :unprocessable_entity
  end

  test "Error when password challenge is wrong" do
    user = FactoryBot.create(:user)
    sign_in(user)

    # wrong challenge
    put settings_password_path, params: {
      user: {
        password_challenge: "wrong_password",
        password: "password",
        password_confirmation: "password"
      }
    }

    assert_response :unprocessable_entity
  end

  test "Password change when password challenge is correct" do
    user = FactoryBot.create(:user)
    sign_in(user)

    # success
    put settings_password_path, params: {
      user: {
        password_challenge: "passwords",
        password: "password",
        password_confirmation: "password"
      }
    }

    assert_response :redirect, message: "Votre mot de passe à bien été changé !"
  end
end
