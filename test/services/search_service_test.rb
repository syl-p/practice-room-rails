require "test_helper"

class SearchServiceTest < ActiveSupport::TestCase
  setup do
    @user1 = FactoryBot.create(:user, username: "alice")
    @user2 = FactoryBot.create(:user, username: "bob_practicer")
    @activity1 = FactoryBot.create(:activity, title: "Guitar Practice")
    @activity2 = FactoryBot.create(:activity, title: "Piano Practice")
  end

  test "returns users and activities matching the search term" do
    search_service = SearchService.new("Practice")
    results = search_service.results

    assert_not_includes results[:users], @user1
    assert_includes results[:users], @user2
    assert_includes results[:activities], @activity1
    assert_includes results[:activities], @activity2
  end
end
