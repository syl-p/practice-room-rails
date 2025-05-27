class DashboardController < ApplicationController
  def index
    @current_date = parse_date(params[:date]) || Date.current
    @start_at = @current_date.beginning_of_week
    @end_at = @current_date.end_of_week
    @practice_time_by_day = Current.user.practiced_activities.where(created_at: @start_at..@end_at)
                                   .select("DATE(created_at) as date, SUM(duration) as duration")
                                   .group("date")

    @practises = Current.user.practiced_activities.at(@current_date.beginning_of_day, @current_date.end_of_day)
  end

  private

  def parse_date(date_param)
    return nil if date_param.blank?

    Date.parse(date_param.to_s)
  rescue ArgumentError
    nil
  end
end
