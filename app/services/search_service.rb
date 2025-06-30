class SearchService < ApplicationService
  def initialize(term)
    @term = term
  end

  def call
    results = {
      users: [],
      activities: [],
    }

    return results unless @term.present?

    users = User.where("username LIKE ?", "%#{@term}%").limit(5)
    activities = Activity.where("title LIKE ?", "%#{@term}%").limit(10)

    results = {
      users: users,
      activities: activities
    }
  end
end
