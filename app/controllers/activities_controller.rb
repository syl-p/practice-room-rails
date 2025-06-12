class ActivitiesController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :set_activity, only: [ :show, :edit, :update, :destroy ]

  def index
    @activities = Activity.preload(:tags, :user).limit(10).order(created_at: :desc)
  end

  def show
    authorize!(@activity)
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.user = Current.user

    if @activity.save
      redirect_to @activity, notice: "Activity was successfully created."
    else
      render :new
    end
  end

  def edit
    authorize! @activity
  end

  def update
    authorize!(@activity)

    if @activity.update(activity_params)
      redirect_to @activity, notice: "Activity was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    authorize!(@activity)

    @activity.destroy
    redirect_to activities_url, notice: "Activity was successfully destroyed."
  end

  private

  def set_activity
    @activity = Activity.preload(:tags, :user, :comments).find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:title, :description, :content, medium_ids: [])
  end
end
