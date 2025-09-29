class Practices::ActivitiesController < ApplicationController
  before_action :set_practice
  def index
    if @practice
      tag_ids = @practice.tags.pluck(:id)
      @activities = ActivitiesService.call(tag_ids:)

      # set session
      session[:current_practice_id] = @practice.id
    else
      redirect_to new_practice_path, flash: { error: "Veuillez créer une pratique" }
    end
  end

  def filter
    tag_ids = params[:tag_ids].blank? ? @practice.tags.pluck(:id) : params[:tag_ids]
    @activities = ActivitiesService.call(tag_ids:, in_favorite:  params[:in_favorite])
  end

  private
  def set_practice
    @practice = Practice.find(params[:practice_id])
  end
end
