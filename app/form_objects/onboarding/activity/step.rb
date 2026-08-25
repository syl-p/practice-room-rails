class Onboarding::Activity::Step
  include ActiveModel::Model
  include ActiveModel::Attributes

  # @param [Activity] activity
  def initialize(activity, params = {})
    @activity = activity
    super(params)
    prefill_step
  end

  def call
    return false unless valid?
    perform
  end

  def perform
    raise NotImplementedError
  end

  def prefill_step
    raise NotImplementedError
  end
end
