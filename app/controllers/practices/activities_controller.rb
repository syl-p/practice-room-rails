class Practices::ActivitiesController < ApplicationController
  before_action :set_practice
  before_action :set_activity, only: [ :show ]

  def show
    authorize!(@activity)
    @practice_activity = @practice.practice_activities.find_by(activity: @activity)
  end

  def index
    @activities = Practices::ActivitiesService.new(@practice.id, tag_ids).call
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(:activities, partial: "practices/activities/list", locals: { activities: @activities, practice: @practice }),
          turbo_stream.update(:activities_count, @activities.count)
        ]
      end
      format.html
    end
  end

  private
  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_practice
    @practice = Practice.find(params[:practice_id])
  end

  def tag_ids
    case params[:tag_ids]
    when Array
      params[:tag_ids]
    when String
      params[:tag_ids].split(",")
    else
      []
    end
  end
end
