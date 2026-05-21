require "test_helper"

class PracticeEntriesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated cannot save a practice_entry" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    post practice_practice_entries_path(practice_id: practice.id), params: {
      activity_id: activity.id,
      duration: 30
    }
    assert_response :redirect
  end

  test "authenticated user can save a practice_entry" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_difference "PracticeEntry.count", 1 do
      post practice_practice_entries_path(practice_id: practice.id), params: {
        activity_id: activity.id,
        duration: 30
      }, as: :turbo_stream
    end

    assert_response :success
  end

  test "fails to create practice_entry without duration" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_no_difference("PracticeEntry.count") do
      post practice_practice_entries_path(practice_id: practice.id), params: {
        activity_id: activity.id,
        duration: nil
      }, as: :turbo_stream
    end

    assert_equal "Duration doit être rempli(e) et Duration n'est pas un nombre", flash[:error]
  end

  test "user cannot provide a invalid duration" do
    practice = FactoryBot.create(:practice)
    activity = FactoryBot.create(:activity)
    sign_in(practice.user)

    assert_no_difference("PracticeEntry.count") do
      post practice_practice_entries_path(practice_id: practice.id), params: {
        activity_id: activity.id,
        duration: "not valid !"
      }, as: :turbo_stream
    end

    assert_equal "Duration n'est pas un nombre", flash[:error]
  end

  test "unauthenticated cannot destroy a practice_entry" do
    practice_entry = FactoryBot.create(:practice_entry)
    delete practice_practice_entry_path(practice_entry, practice_id: practice_entry.practice.id)
    assert_response :redirect
  end

  test "authenticated user can destroy is own practice_entry" do
    practice = FactoryBot.create(:practice)
    practice_entry = FactoryBot.create(:practice_entry, user: practice.user, practice: practice)
    sign_in(practice.user)

    assert_difference "PracticeEntry.count", -1 do
      delete practice_practice_entry_path(practice_entry, practice_id: practice.id), as: :turbo_stream
    end
    assert_response :success
  end

  test "authenticated user cannot destroy another user's practice_entry" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    practice_entry = FactoryBot.build(:practice_entry, user: user2)
    practice_entry.save
    sign_in(user1)
    assert_no_difference "PracticeEntry.count" do
      delete practice_practice_entry_path(practice_entry, practice_id: practice_entry.id), as: :turbo_stream
    end
    assert_response :not_found
  end
end
