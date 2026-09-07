class ActivitiesController < ApplicationController
  allow_unauthenticated_access only: [ :show ]
  before_action :set_activity, only: [ :show ]

  def show
    authorize!(@activity)
  end

  def set_activity
    @activity = Activity.find(params[:id])
  end
end
