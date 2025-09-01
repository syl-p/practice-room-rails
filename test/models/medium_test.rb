require "test_helper"

class MediumTest < ActiveSupport::TestCase
  test "Medium must have file" do
    medium = Medium.new
    assert !medium.valid?
    assert medium.errors[:file].any?
  end

  test "Medium prevent not allowed extension file" do
    file = File.new(Rails.root.join("test/fixtures/files/bad_extension_file.csv"))
    user = FactoryBot.create(:user)
    medium = Medium.create file: file, user: user

    assert medium.errors.any?
    assert_equal medium.errors.messages[:file].first, "Must be a valid file extension"
  end

  test "Medium accept allowed extension file" do
    file = File.new(Rails.root.join("test/fixtures/files/avatar.png"))
    user = FactoryBot.create(:user)
    medium = Medium.create file: file, user: user

    assert_not medium.errors.any?
  end
end
