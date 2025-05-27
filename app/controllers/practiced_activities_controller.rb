class PracticedActivitiesController < ApplicationController
  def create
    @practiced_activity = PracticedActivity.new(activity_id: params[:activity_id], user: Current.user, duration: params[:duration].to_i)
    if @practiced_activity.save
      # turbo stream response to update the dashboard
      respond_to do |format|
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
end
