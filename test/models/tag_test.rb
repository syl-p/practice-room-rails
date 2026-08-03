require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "tag name must be present" do
    tag = Tag.new
    assert_not tag.valid?
    assert tag.errors[:name].any?
  end
  test "tag name must be capitalized" do
    tag = Tag.new(name: "test")
    tag.save
    assert_equal "Test", tag.name
  end

  test "tag name must be unique" do
    Tag.create(name: "test")

    tag_with_error = Tag.new(name: "test")
    assert_not tag_with_error.valid?
    assert tag_with_error.errors.any?
  end

  test "get practice_entries duration by tags" do
    practice = FactoryBot.create(:practice)
    tag = FactoryBot.create(:tag)
    activity = FactoryBot.create(:activity)
    user = FactoryBot.create(:user)
    activity.tags << tag

    practice.tags << tag
    practice.activities << activity

    PracticeEntry.create(practice:, activity:, user:, duration: 5)
    PracticeEntry.create(practice:, activity:, user:, duration: 10)

    tags_by_duration = Tag.for_practice_with_duration(practice.id)

    assert_not_empty tags_by_duration
    assert tags_by_duration.first&.duration, 15
  end
end
