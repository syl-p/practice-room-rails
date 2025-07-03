class PracticedActivitiesController < ApplicationController
  before_action :set_activity, only: [ :create ]

  def create
    @practiced_activity = PracticedActivity.new(activity: @activity, user: Current.user, duration: params[:duration].to_i)

    if @practiced_activity.save
      # turbo stream response to update the dashboard
      respond_to do |format|
        flash[:success] = "Votre temps de pratique à été mise à jour."
        format.turbo_stream
      end
    else
      flash[:alert] = "Failed to practice activity."
      redirect_to dashboard_path
    end
  end

  def destroy
    @practiced_activity = Current.user.practiced_activities.find(params[:id])
    @practiced_activity.destroy
  end

  private
  def set_activity
    @activity = Activity.find(params[:activity_id])
  end
end
