class DashboardController < ApplicationController
  def index
    @current_date = parse_date(params[:date]) || Date.current
    @start_at = @current_date.beginning_of_week
    @end_at = @current_date.end_of_week

    @practices = Current.user.practiced_activities.at(@current_date.beginning_of_day, @current_date.end_of_day)
    @practice_time_by_day = @practices.select("DATE(created_at) as date, SUM(duration) as duration")
                                      .group("date")


    practices_activities_service = PracticedActivitiesService.new(
      user: Current.user,
      start_at: @current_date.beginning_of_day,
      end_at: @current_date.end_of_day
    )

    @stats = {
      more_than_10_mn_today: practices_activities_service.more_than_10_mn_today?,
      have_3_exercises_today: practices_activities_service.have_3_exercises_today?,
    }
  end

  private

  def parse_date(date_param)
    return nil if date_param.blank?

    Date.parse(date_param.to_s)
  rescue ArgumentError
    nil
  end
end
