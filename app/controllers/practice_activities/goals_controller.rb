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
      redirect_to practice_activity_goal_path(practice_activity_id: @practice_activity.id,
                                              id: @goal.id
                  ), flash: { success: "Goal was successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  # def update
  #   if @goal.update(goal_params)
  #     redirect_to practice_activity_goal_goal_progresses_path(
  #                   practice_id: @practice_activity.practice_id,
  #                   activity_id: @practice_activity.id,
  #                   goal_id: @goal.id
  #                 ), flash: { success: "Goal was successfully updated." }
  #   else
  #     render :show, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @goal.destroy
  #   flash[:success] = "Goal deleted!"
  #   redirect_to practice_path(@practice_activity.activity)
  # end

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
