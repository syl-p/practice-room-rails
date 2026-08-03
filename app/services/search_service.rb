class SearchService
  attr_reader :results

  def initialize(term)
    @term = term
    @results = {
      users: [],
      activities: []
    }

    return results unless @term.present?

    @results[:users] = User.where("username LIKE ?", "%#{@term}%").limit(5)
    @results[:activities] = Activity.where("title LIKE ?", "%#{@term}%").limit(10)
  end
end
