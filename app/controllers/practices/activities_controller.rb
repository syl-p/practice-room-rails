class Practices::ActivitiesController < ApplicationController
  include CurrentPractice
  set_practice_id_param :practice_id

  before_action :set_activity, only: [ :show, :destroy ]

  def show
    authorize!(@activity)
    @practice_activity = @practice.practice_activities.find_by(activity: @activity)
  end

  def index
    @activities = Practices::ActivitiesService.new(@practice).filter_by_tags(tag_ids)

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

  def destroy
    authorize!(@activity)

    @activity.destroy
    redirect_to @practice, flash: { success: "Activité supprimée." }
  end

  private
  def set_activity
    @activity = Activity.find(params[:id])
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
