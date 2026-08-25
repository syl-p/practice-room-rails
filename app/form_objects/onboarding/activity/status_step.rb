class Onboarding::Activity::StatusStep < Onboarding::Activity::Step
  attribute :status, :string, default: :draft
  validates :status, presence: true

  def perform
    @activity.assign_attributes(status:)
    @activity.save!
  end

  def self.permitted_params
    %i[status]
  end

  private
  def prefill_step
    self.status = @activity.status
  end
end