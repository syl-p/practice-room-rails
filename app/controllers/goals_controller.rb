class GoalsController < ApplicationController
  before_action :set_goal, only: [ :show, :edit, :update ]

  def show
  end

  def edit
  end

  def update
    authorize! @goal, :update?

    if @goal.update(goal_params)
      redirect_to @goal
    else
      render :edit
    end
  end

  private
  def set_goal
    @goal = Current.user.goals.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:target_value, :unit)
  end
end
