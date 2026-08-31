class Practices::PracticeActivitiesController < ApplicationController
  include CurrentPractice
  set_practice_id_param :practice_id

  before_action :set_activity, only: :create
  before_action :set_practice_activity, only: :destroy

  def create
    authorize!(@practice, :attach?)
    @practice.activities << @activity
    @practice.save
    flash[:success] = "Activité ajoutée à votre pratique !"
    redirect_to practice_path(@practice)
  rescue
    flash[:error] = "Cette activité est déjà dans votre pratique"
    redirect_to practice_path(@practice)
  end

  def destroy
    authorize! @practice_activity

    @practice_activity.destroy
    flash[:success] = "Activité détachée de votre pratique."
    redirect_to practice_path(@practice)
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def set_practice_activity
    @practice_activity = PracticeActivity.find_by(practice_id: params[:practice_id], activity_id: params[:id])
  end
end
