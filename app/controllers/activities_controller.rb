class ActivitiesController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :set_activity, only: [ :show, :edit, :update, :destroy ]
  include PracticesHelper

  def index
    if authenticated?
      if current_practice.present?
        tag_ids = current_practice.tags.pluck(:id)
        @activities = ActivitiesService.call(tag_ids:)
      else
        redirect_to new_practice_path, flash: { error: "Veuillez créer une pratique" }
      end
    else
      @activities = Activity.published.order(created_at: :desc).limit(10)
    end
  end

  def filter
    tag_ids = params[:tag_ids].blank? ? current_practice.tags.pluck(:id) : params[:tag_ids]
    @activities = ActivitiesService.call(tag_ids:, in_favorite:  params[:in_favorite])
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
      redirect_to @activity, flash: {success: "Bravo ! Votre activité à été créée."}
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
      redirect_to @activity, flash: {success: 'Votre activité à été mise à jour.'}
    else
      render :edit
    end
  end

  def destroy
    authorize!(@activity)

    @activity.destroy
    redirect_to activities_url, flash: {success: "Activity was successfully destroyed."}
  end

  private

  def set_activity
    @activity = Activity.preload(:tags, :user, :comments).find(params[:id])
  end

  def activity_params
    raw_params = params.require(:activity).permit(:title, :content, :status, :tag_ids, medium_ids: [])
    raw_params[:tag_ids] = raw_params[:tag_ids].to_s.split(",").reject(&:blank?)
    raw_params
  end
end
