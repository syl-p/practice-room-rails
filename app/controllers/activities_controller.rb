class ActivitiesController < ApplicationController
  allow_unauthenticated_access only: [ :show ]
  before_action :set_activity, only: [ :show, :edit, :update, :destroy ]

  def show
    authorize!(@activity)
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.user = Current.user

    tags = params[:tag_labels].to_s.split(",").reject(&:blank?)
    if tags.present?
      @activity.tags = find_tags(tags)
    end

    if @activity.save
      redirect_to @activity, flash: { success: "Bravo ! Votre activité à été créée." }
    else
      render :new
    end
  end

  def edit
    authorize! @activity
  end

  def update
    authorize!(@activity)

    tags = params[:tag_labels].to_s.split(",").reject(&:blank?)
    if tags.present?
      @activity.tags = find_tags(tags)
    end

    if @activity.update(activity_params)
      redirect_to @activity, flash: { success: "Votre activité à été mise à jour." }
    else
      render :edit
    end
  end

  def destroy
    authorize!(@activity)

    @activity.destroy
    redirect_to activities_url, flash: { success: "Activity was successfully destroyed." }
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:title, :content, :status, medium_ids: [])
  end

  def find_tags(labels)
    Tag.where(name: labels)
  end
end
