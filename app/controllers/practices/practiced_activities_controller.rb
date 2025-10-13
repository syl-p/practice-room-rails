class Practices::PracticedActivitiesController < ApplicationController
  before_action :set_practice
  before_action :set_activity, only: [ :create ]
  before_action :set_duration, only: [ :create ]
  before_action :set_practiced_activity, only: [ :destroy ]

  def index
    session[:current_practice_id] = @practice.id

    @current_date = parse_date(params[:date]) || Date.today
    @start_at = @current_date.beginning_of_week
    @end_at = @current_date.end_of_week
    @practiced_activities = Current.user
                                   .practiced_activities.at(@start_at, @end_at)
                                   .where(practice_id: @practice.id)
  end

  def create
    @practiced_activity = PracticedActivity.new(
      activity: @activity,
      user: Current.user,
      duration: @duration,
      practice: @practice,
    )

    if @practiced_activity.save
      flash[:success] = "Votre temps de pratique à été mise à jour."
    end
  end

  def destroy
    @practiced_activity.destroy
    flash[:success] = "Votre temps de pratique à été mise à jour."
  end

  private
  def set_practiced_activity
    @practiced_activity = Current.user.practiced_activities.find(params[:id])
  end

  def set_duration
    begin
      @duration = Integer(params[:duration])
      raise ArgumentError if @duration <= 0
    rescue ArgumentError, TypeError
      flash[:alert] = "Duration not valid."
      render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") and return
    end
  end

  def set_activity
    begin
      @activity = Activity.find(params[:activity_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Activity not found."
    end
  end

  def set_practice
    begin
      @practice = Practice.find(params[:practice_id]) || session[:current_practice_id]
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Practice not found."
    end
  end

  def parse_date(date_param)
    return nil if date_param.blank?

    Date.parse(date_param.to_s)
  rescue ArgumentError
    nil
  end
end
