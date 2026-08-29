class Onboarding::Practice::Step
  include ActiveModel::Model
  include ActiveModel::Attributes

  # @param [Practice] practice
  def initialize(practice, params = {})
    @practice = practice
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
