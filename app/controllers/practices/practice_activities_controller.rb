class Practices::PracticeActivitiesController < ApplicationController
  before_action :set_practice_activity, only: :destroy
  before_action :set_practice, only: :create
  before_action :set_activity, only: :create

  def create
    authorize!(@practice, :attach?)
    @practice.activities << @activity
    @practice.save
    flash[:success] = "Activity Attached!"
    redirect_to practice_path(@practice)
  rescue
    flash[:error] = "Activity already attached"
    redirect_to practice_path(@practice)
  end

  def destroy
    authorize!(@practice, :detach?)
    @practice_activity.destroy
    flash[:success] = "Activity Detached!"
    redirect_to practice_path(@practice)
  end

  private
  def set_practice
    @practice = Practice.find(params[:practice_id])
  end

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def set_practice_activity
    @practice_activity = PracticeActivity.find(params[:id])
  end
end
