class Practices::ActivitiesService
  # @param [Number] practice_id
  # @param [Array<Number>] tags_ids
  def initialize(practice_id, tags_ids)
    @practice = Practice.find(practice_id)
    @tag_ids = tags_ids || []
  end

  # @return [Array<Activity>]
  def call
    activities = @practice.activities

    if @tag_ids.any?
      activities = activities
                     .joins(:tags)
                     .where(tags: { id: @tag_ids })
                     .distinct
    end

    activities
  end
end
