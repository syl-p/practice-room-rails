class Onboarding::Practice::ContentStep < Onboarding::Practice::Step
  attribute :name, :string
  attribute :description, :string

  validates :name, presence: true
  validates :description, presence: true

  def perform
    @practice.assign_attributes({ name:, description: })
    @practice.save!
  end

  def self.permitted_params
    %i[name description]
  end

  private

  def prefill_step
    self.name ||= @practice.name
    self.description ||= @practice.description if @practice.description.present?
  end
end
