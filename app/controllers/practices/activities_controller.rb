class Practices::ActivitiesController < ApplicationController
  before_action :set_practice
  before_action :set_activity, only: [ :show, :attach_to ]

  def show
    authorize!(@activity)
  end

  def attach_to
    authorize(@activity)
    @practice.activities << @activity
    @practice.save
    flash[:success] = "Activity Attached!"
  end

  def filter
    tag_ids = params[:tag_ids].blank? ? @practice.tags.pluck(:id) : params[:tag_ids]
    @activities = ActivitiesService.call(tag_ids:, in_favorite:  params[:in_favorite])
  end

  private
  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_practice
    @practice = Practice.find(params[:practice_id])
  end
end
