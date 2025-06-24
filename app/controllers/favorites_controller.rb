class FavoritesController < ApplicationController
  before_action :set_activity, only: [ :create, :destroy ]

  def create
    Current.user.favorites << @activity
  end

  def destroy
    Current.user.favorites.delete(@activity)
  end

  private
  def set_activity
    @activity = Activity.find(params[:activity_id])
  end
end
