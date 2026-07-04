class Practices::ActivitiesService
  # @param [Practice] practice
  def initialize(practice)
    @practice = practice
    @user = @practice.user
  end

  # @param [Array<Number>] tags_ids
  # @return [Array<Activity>]
  def filter_by_tags(tags_ids = [])
    activities = @practice.activities

    if tags_ids.any?
      activities = activities
                     .joins(:tags)
                     .where(tags: { id: tags_ids })
                     .distinct
    end

    activities
  end

  # @param [Number] limit
  # @return [Array<Activity>]
  def top_practiced_activities(limit = 10)
    @practice.activities.joins(:practice_entries).where("practice_entries.user_id": @user.id).group(:id).order("SUM(practice_entries.duration) desc").limit(limit)
  end
end
