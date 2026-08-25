module Onboarding::Activities::StepHelper
  STEP_LABELS = {
    "content" => "Contenu",
    "tags" => "Tags",
    "status" => "Statut",
    "media" => "Médias"
  }.freeze

  # @param [String] step
  # @return [String]
  def step_nav_url(step)
    @activity.persisted? ? onboarding_activity_step_path(@activity, step) : onboarding_activities_new_path
  end

  # @param [String] step
  # @return [String]
  def step_nav_label(step)
    STEP_LABELS.fetch(step, step.humanize)
  end

  # only the first step is reachable until the activity is created
  # @param [String] step
  # @return [Boolean]
  def step_nav_enabled?(step)
    @activity.persisted? || step == Onboarding::Activity::STEPS.first
  end

  # @param [String] step
  # @return [String]
  def step_nav_classes(step)
    [
      "inline-flex items-center gap-1.5 rounded-full px-3 py-1.5 text-sm font-medium transition-colors",
      step == @step ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-secondary hover:text-secondary-foreground",
      ("pointer-events-none opacity-50" unless step_nav_enabled?(step))
    ].compact.join(" ")
  end
end
