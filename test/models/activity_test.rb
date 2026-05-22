require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  test "should have a valid factory" do
    activity = FactoryBot.build(:activity)
    assert activity.valid?
  end

  test "should be invalid without a title" do
    activity = FactoryBot.build(:activity, title: nil)
    assert_not activity.valid?
    assert_includes activity.errors[:title], "doit être rempli(e)"
  end

  test "should be invalid without content" do
    activity = FactoryBot.build(:activity, content: nil)
    assert_not activity.valid?
    assert_includes activity.errors[:content], "doit être rempli(e)"
  end

  test "slug must be unique" do
    FactoryBot.create(:activity, slug: "my-slug")
    duplicate = FactoryBot.build(:activity, slug: "my-slug")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:slug], "est déjà utilisé(e)"
  end

  test "slug should be generated after validation" do
    activity = FactoryBot.build(:activity, title: "My Activity", slug: nil)
    activity.valid? # Trigger validations
    assert_not_nil activity.slug
    assert_equal "my-activity", activity.slug
  end

  test "slug should be unique even with similar titles" do
    activity1 = FactoryBot.create(:activity, title: "My Activity", slug: nil)
    activity2 = FactoryBot.build(:activity, title: "My Activity", slug: nil)
    activity2.valid? # Trigger validations

    assert_not_equal activity1.slug, activity2.slug
    assert_match(/my-activity-\d+/, activity2.slug)
  end
end
