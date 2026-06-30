class GoalsController < ApplicationController
  before_action :set_goal, only: [ :show ]

  def show
  end

  private
  def set_goal
    @goal = Current.user.goals.find(params[:id])
  end
end
