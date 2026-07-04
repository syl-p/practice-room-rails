require "test_helper"

class Practices::ActivitiesServiceTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @practice = FactoryBot.create(:practice, user: @user)
    @service = Practices::ActivitiesService.new(@practice)
  end

  test "filter_by_tags returns all activities when no tag ids given" do
    activities = FactoryBot.create_list(:activity, 3)
    @practice.activities << activities

    result = @service.filter_by_tags([])

    assert_equal 3, result.length
  end

  test "filter_by_tags returns activities matching the given tag" do
    tag = FactoryBot.create(:tag)
    matching_activity = FactoryBot.create(:activity)
    matching_activity.tags << tag
    other_activity = FactoryBot.create(:activity)

    @practice.activities << [ matching_activity, other_activity ]

    result = @service.filter_by_tags([ tag.id ])

    assert_equal [ matching_activity ], result
  end

  test "filter_by_tags returns activities matching any of multiple tags" do
    tag1 = FactoryBot.create(:tag)
    tag2 = FactoryBot.create(:tag)
    activity1 = FactoryBot.create(:activity)
    activity1.tags << tag1
    activity2 = FactoryBot.create(:activity)
    activity2.tags << tag2
    @practice.activities << [ activity1, activity2 ]

    result = @service.filter_by_tags([ tag1.id, tag2.id ])

    assert_includes result, activity1
    assert_includes result, activity2
    assert_equal 2, result.length
  end

  test "filter_by_tags returns unique activities when an activity has multiple matching tags" do
    tag1 = FactoryBot.create(:tag)
    tag2 = FactoryBot.create(:tag)
    activity = FactoryBot.create(:activity)
    activity.tags << [ tag1, tag2 ]
    @practice.activities << activity

    result = @service.filter_by_tags([ tag1.id, tag2.id ])

    assert_equal [ activity ], result
  end

  test "filter_by_tags does not return activities from other practices" do
    tag = FactoryBot.create(:tag)
    activity = FactoryBot.create(:activity)
    activity.tags << tag
    other_practice = FactoryBot.create(:practice)
    other_practice.activities << activity

    @practice.activities << FactoryBot.create(:activity)

    result = @service.filter_by_tags([ tag.id ])

    assert_empty result
  end

  test "top_practiced_activities returns activities ordered by total duration descending" do
    activity1 = FactoryBot.create(:activity)
    activity2 = FactoryBot.create(:activity)
    @practice.activities << [ activity1, activity2 ]

    FactoryBot.create(:practice_entry, practice: @practice, activity: activity1, user: @user, duration: 10)
    FactoryBot.create(:practice_entry, practice: @practice, activity: activity2, user: @user, duration: 30)

    result = @service.top_practiced_activities(5)

    assert_equal [ activity2, activity1 ], result
  end

  test "top_practiced_activities only considers entries from the practice owner" do
    activity = FactoryBot.create(:activity)
    @practice.activities << activity
    other_user = FactoryBot.create(:user)

    FactoryBot.create(:practice_entry, practice: @practice, activity: activity, user: @user, duration: 30)
    FactoryBot.create(:practice_entry, practice: @practice, activity: activity, user: other_user, duration: 999)

    result = @service.top_practiced_activities(5)

    assert_equal [ activity ], result
  end

  test "top_practiced_activities aggregates duration across multiple entries for the same activity" do
    activity = FactoryBot.create(:activity)
    @practice.activities << activity

    FactoryBot.create(:practice_entry, practice: @practice, activity: activity, user: @user, duration: 15)
    FactoryBot.create(:practice_entry, practice: @practice, activity: activity, user: @user, duration: 25)

    result = @service.top_practiced_activities(5)

    assert_equal [ activity ], result
  end

  test "top_practiced_activities ignores activities with no practice entries" do
    activity_with_entries = FactoryBot.create(:activity)
    activity_without_entries = FactoryBot.create(:activity)
    @practice.activities << [ activity_with_entries, activity_without_entries ]

    FactoryBot.create(:practice_entry, practice: @practice, activity: activity_with_entries, user: @user, duration: 10)

    result = @service.top_practiced_activities(5)

    assert_equal [ activity_with_entries ], result
  end
end
