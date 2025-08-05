class ActivitiesService < ApplicationService
  def initialize(options)
    @tag_ids = options[:tag_ids]
    @in_favorites = options[:in_favorite]
  end

  def call
    if @in_favorites.present?
      activities = Current.user.favorites
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
      .limit(10)
  end
end
