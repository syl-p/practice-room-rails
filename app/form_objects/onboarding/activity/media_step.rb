class Onboarding::Activity::MediaStep < Onboarding::Activity::Step
  attribute :medium_ids, default: -> { [] }

  def perform
    @activity.medium_ids = medium_ids
    @activity.save!
  end

  def self.permitted_params
    [medium_ids: []]
  end

  def prefill_step
    self.medium_ids ||= @activity.media.map(&:signed_id)
  end
end
