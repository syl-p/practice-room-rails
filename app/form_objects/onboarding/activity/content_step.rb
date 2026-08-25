class Onboarding::Activity::ContentStep < Onboarding::Activity::Step
  attribute :title, :string
  attribute :content, :string

  validates :title, presence: true
  validates :content, presence: true

  def perform
    @activity.assign_attributes({ title:, content: })
    @activity.save!
  end

  def self.permitted_params
    %i[title content]
  end

  private

  def prefill_step
    self.title ||= @activity.title
    self.content ||= @activity.content if @activity.content.present?
  end
end