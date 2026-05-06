require "test_helper"

class Practices::ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should list activities for a practice" do
    practice = FactoryBot.create(:practice)
    activity1 = FactoryBot.create(:activity, :public)
    activity2 = FactoryBot.create(:activity, :public)
    practice.activities << activity1
    practice.activities << activity2

    sign_in(practice.user)

    get practice_activities_url(practice)
    assert_response :success

    assert_match activity1.title, response.body
    assert_match activity2.title, response.body
  end

  test "should filter activities by tags when tag_ids params are provided" do
    practice = FactoryBot.create(:practice)
    tag1 = FactoryBot.create(:tag)
    tag2 = FactoryBot.create(:tag)
    practice.tags << tag1
    practice.tags << tag2

    activity1 = FactoryBot.create(:activity, :public)
    activity2 = FactoryBot.create(:activity, :public)
    activity1.tags << tag1
    activity2.tags << tag2

    practice.activities << activity1
    practice.activities << activity2

    sign_in(practice.user)

    get practice_activities_url(practice, tag_ids: [ tag1.id ])

    assert_response :success

    assert_match activity1.title, response.body
    assert_no_match activity2.title, response.body
  end
end
