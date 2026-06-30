class PracticeActivities::GoalsController < ApplicationController
  before_action :set_practice_activity
  before_action :set_goal, only: [ :show ]

  def show
  end

  def new
    @goal = Goal.new(practice_activity: @practice_activity)
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user = Current.user
    @goal.practice_activity = @practice_activity

    if @goal.save
      redirect_to goal_path(id: @goal.id), flash: { success: "Goal was successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_practice_activity
    @practice_activity = PracticeActivity.find(params[:practice_activity_id])
  end

  def set_goal
    @goal = Current.user.goals.find_by(practice_activity: @practice_activity)
  end

  def goal_params
    params.require(:goal).permit(:target_value, :unit)
  end
end
