class Practices::TagsService
  # @param [Practice] practice
  def initialize(practice)
    @practice = practice
  end

  def top_tags(limit = 10)
    @practice.tags.limit(limit)
  end
end