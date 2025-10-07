class Practices::ActivitiesController < ApplicationController
  before_action :set_practice
  before_action :set_stats, only: [ :index ]

  def index
    if @practice
      tag_ids = @practice.tags.pluck(:id)
      @activities = ActivitiesService.call(tag_ids:)

      # set session
      session[:current_practice_id] = @practice.id
    else
      redirect_to new_practice_path, flash: { error: "Veuillez créer une pratique" }
    end
  end

  def filter
    tag_ids = params[:tag_ids].blank? ? @practice.tags.pluck(:id) : params[:tag_ids]
    @activities = ActivitiesService.call(tag_ids:, in_favorite:  params[:in_favorite])
  end

  private
  def set_practice
    @practice = Practice.find(params[:practice_id])
  end

  def set_stats
    current_date = Date.today
    practices_activities_service = PracticedActivitiesService.new(
      user: Current.user,
      practice_id: @practice.id,
      start_at: current_date.beginning_of_day,
      end_at: current_date.end_of_day
    )

    @stats = {
      more_than_10_mn_today: practices_activities_service.more_than_10_mn_today?,
      have_3_exercises_today: practices_activities_service.have_3_exercises_today?
    }
  end
end
