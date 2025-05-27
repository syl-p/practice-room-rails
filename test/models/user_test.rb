require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should have a valid factory" do
    user = FactoryBot.build(:user)
    assert user.valid?
  end

  test "should be invalid without an email address" do
    user = FactoryBot.build(:user, email_address: nil)
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "should be invalid without a password" do
    user = FactoryBot.build(:user, password: nil)
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "password must be confirmed" do
    user = FactoryBot.build(:user, password: "password", password_confirmation: "different")
    assert_not user.valid?
    assert_includes user.errors[:password_confirmation], "doesn't match Password"
  end

  test "check email address format" do
    user = FactoryBot.build(:user, email_address: "invalid_email")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "must be a valid email address"
  end

  test "email address should be unique" do
    FactoryBot.create(:user, email_address: "test@test.test")
    user = FactoryBot.build(:user, email_address: "test@test.test")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end
end
