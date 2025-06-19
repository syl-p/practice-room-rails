class SearchService < ApplicationService
  def initialize(term)
    @term = term
  end

  def call
    {} if @term.blank?

    users = User.where("username LIKE ?", "#{@term}%").limit(5)
    activities = Activity.where("title LIKE ?", "#{@term}%").limit(10)

    {
      users: users,
      activities: activities
    }
  end
end
