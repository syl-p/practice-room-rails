class Practices::ActivitiesController < ApplicationController
  before_action :set_practice
  before_action :set_activity, only: [ :show, :attach, :detach ]

  def show
    authorize!(@activity)
  end

  def filter
    @activities = Practices::ActivitiesService.new(@practice.id, params[:tag_ids]).call
  end

  def attach
    authorize!(@practice)
    @practice.activities << @activity
    @practice.save

    flash[:success] = "Activity Attached!"
    redirect_to practice_path(@practice)
  end

  def detach
    authorize!(@practice)
    @practice.activities.delete(@activity)

    flash[:success] = "Activity Detached!"
  end

  private
  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_practice
    @practice = Practice.find(params[:practice_id])
  end
end
