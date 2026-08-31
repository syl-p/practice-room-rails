class Goals::GoalProgressesController < ApplicationController
  before_action :goal_progress_params, only: [ :index, :create ]
  before_action :set_goal, only: [ :index, :create ]

  def index
    @goal_progress = GoalProgress.new
    @goal_progress.goal_id = @goal.id
  end

  def create
    @goal_progress = @goal.progresses.where(created_at: Date.today.all_day).order(created_at: :desc).first_or_create
    @goal_progress.value = goal_progress_params[:value]

    if @goal_progress.save
      flash[:success] = "Progression enregistrée !"
    else
      flash[:error] = "Oups, une erreur est survenue. Réessayez."
    end
  end

  private
  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def goal_progress_params
    params.require(:goal_progress).permit(:goal_id, :value)
  end
end
