class GoalsController < ApplicationController
  before_action :set_goal, only: [ :show, :edit, :update ]

  def show
  end

  def edit
  end

  def update
  end

  private
  def set_goal
    @goal = Current.user.goals.find(params[:id])
  end
end
