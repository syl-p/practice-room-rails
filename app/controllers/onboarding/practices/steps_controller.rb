class Onboarding::Practices::StepsController < ApplicationController
  before_action :set_practice
  before_action :set_step

  def show
    return redirect_to onboarding_practices_new_path if creation_locked_step?

    @step_object = step_class.new(@practice)
    render "onboarding/practices/steps/#{@step.downcase}"
  end

  def update
    @step_object = step_class.new(@practice, step_params)
    if @step_object.call
      if next_step
        redirect_to onboarding_practice_step_path({ practice_id: @practice.id, step: next_step })
      else
        flash[:success] = "Votre pratique est prête."
        render "completed", formats: [:turbo_stream]
      end
    else
      render "onboarding/practices/steps/#{@step.downcase}", status: :unprocessable_entity
    end
  end

  private

  # @return [Onboarding::Practice::Step]
  def step_class
    "Onboarding::Practice::#{@step.camelize}Step".constantize
  end

  def set_step
    @step = params[:step] || Onboarding::Practice::STEPS.first
  end

  def next_step
    index = Onboarding::Practice::STEPS.index(@step)
    Onboarding::Practice::STEPS[index + 1]
  end

  # while creating, only the first step is reachable
  def creation_locked_step?
    !@practice.persisted? && @step != Onboarding::Practice::STEPS.first
  end

  def set_practice
    @practice = if params[:practice_id].present?
                  Current.user.practices.find(params[:practice_id])
                else
                  Current.user.practices.build
                end
  end

  # get params from the step_class path key
  # ex: Onboarding::Practice::ContentStep == params[:onboarding_practice_content_step]
  def step_params
    params.require(step_class.model_name.param_key).permit(*step_class.permitted_params)
  end
end