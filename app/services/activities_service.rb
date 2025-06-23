class ActivitiesService < ApplicationService
  def initialize(options)
    @tag_ids = options[:tag_ids]
  end

  def call
    activities = Activity.published
    if @tag_ids.present?
      activities = activities
                        .joins(:tags)
                        .where(tags: {id: @tag_ids})
                        .distinct
                        .order(created_at: :desc)
                        .limit(10)
    end
  end
end