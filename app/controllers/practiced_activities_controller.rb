class PracticedActivitiesController < ApplicationController
  before_action :set_activity, only: [ :create ]
  before_action :set_practice, only: [ :create ]
  before_action :set_duration, only: [ :create ]

  def create
    @practiced_activity = PracticedActivity.new(
      activity: @activity,
      user: Current.user,
      duration: @duration,
      practice: @practice,
    )

    if @practiced_activity.save
      # turbo stream response to update the dashboard
      respond_to do |format|
        flash[:success] = "Votre temps de pratique à été mise à jour."
        format.turbo_stream
      end
    end
  end

  def destroy
    @practiced_activity = Current.user.practiced_activities.find(params[:id])
    @practiced_activity.destroy
  end

  private
  def set_duration
    begin
      raise if params[:duration].blank?
      @duration = params[:duration].to_i
    rescue
      flash[:alert] = "Duration not found."
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
      @practice = Practice.find(params[:practice_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Practice not found."
    end
  end
end
