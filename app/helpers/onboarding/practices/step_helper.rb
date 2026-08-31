module Onboarding::Practices::StepHelper
  STEP_LABELS = {
    "content" => "Contenu",
    "tags" => "Tags"
  }.freeze

  # @param [String] step
  # @return [String]
  def practice_step_nav_url(step)
    @practice.persisted? ? onboarding_practice_step_path(@practice, step) : onboarding_practices_new_path
  end

  # @param [String] step
  # @return [String]
  def practice_step_nav_label(step)
    STEP_LABELS.fetch(step, step.humanize)
  end

  # only the first step is reachable until the practice is created
  # @param [String] step
  # @return [Boolean]
  def practice_step_nav_enabled?(step)
    @practice.persisted? || step == Onboarding::Practice::STEPS.first
  end

  # @param [String] step
  # @return [String]
  def practice_step_nav_classes(step)
    [
      "inline-flex items-center gap-1.5 rounded-full px-3 py-1.5 text-sm font-medium transition-colors",
      step == @step ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-secondary hover:text-secondary-foreground",
      ("pointer-events-none opacity-50" unless practice_step_nav_enabled?(step))
    ].compact.join(" ")
  end
end
