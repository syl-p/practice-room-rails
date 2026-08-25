class Onboarding::Activities::StepsController < ApplicationController
  before_action :set_activity
  before_action :set_step

  def show
    return redirect_to onboarding_activities_new_path if creation_locked_step?

    @step_object = step_class.new(@activity)
    render "onboarding/activities/steps/#{@step.downcase}"
  end

  def update
    @step_object = step_class.new(@activity, step_params)
    if @step_object.call
      if next_step
        redirect_to onboarding_activity_step_path({ activity_id: @activity.id, step: next_step })
      else
        redirect_back fallback_location: onboarding_activity_step_path({ activity_id: @activity.id, step: @step })
      end
    else
      render "onboarding/activities/steps/#{@step.downcase}", status: :unprocessable_entity
    end
  end

  private

  # @return [Onboarding::Activity::Step]
  def step_class
    "Onboarding::Activity::#{@step.camelize}Step".constantize
  end

  def set_step
    @step = params[:step] || Onboarding::Activity::STEPS.first
  end

  def next_step
    index = Onboarding::Activity::STEPS.index(@step)
    Onboarding::Activity::STEPS[index + 1]
  end

  # while creating, only the first step is reachable
  def creation_locked_step?
    !@activity.persisted? && @step != Onboarding::Activity::STEPS.first
  end

  def set_activity
    @activity = if params[:activity_id].present?
      Current.user.activities.find(params[:activity_id])
    else
      Current.user.activities.build
    end
  end

  # get params from the step_class path key
  # ex: Onboarding::Activity::ContentStep == params[:onboarding_activity_content_step]
  def step_params
    params.require(step_class.model_name.param_key).permit(*step_class.permitted_params)
  end
end
