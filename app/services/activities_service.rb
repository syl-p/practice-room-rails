class ActivitiesService < ApplicationService
  def initialize(options)
    @tag_ids = options[:tag_ids]
    @in_bookmarks = options[:in_bookmark]
    @limit = options[:limit] || 10
  end

  def call
    if @in_bookmarks.present?
      activities = Current.user.bookmarks
    else
      activities = Activity.published
    end

    if @tag_ids.present?
      activities = activities
                        .joins(:tags)
                        .where(tags: { id: @tag_ids })
                        .distinct
    end

    activities
      .order(created_at: :desc)
      .limit(@limit)
  end
end
