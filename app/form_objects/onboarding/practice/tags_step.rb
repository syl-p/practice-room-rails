class Onboarding::Practice::TagsStep < Onboarding::Practice::Step
  attribute :labels, :string, default: ""
  validate :labels_presence

  def perform
    @practice.tags = find_or_create_tags(normalized_labels)
  end

  def self.permitted_params
    %i[labels]
  end

  # @return [Array<String>]
  def normalized_labels
    raw = labels.split(",")
    Array(raw).map { |label| label.to_s.strip.capitalize }.reject(&:blank?).uniq
  end

  private
  def find_or_create_tags(labels)
    labels.map { |name| Tag.find_or_create_by!(name: name) }
  end

  def labels_presence
    errors.add :labels, "doit contenir au moins un tag" if normalized_labels.blank?
  end

  def prefill_step
    self.labels ||= @practice.tags.pluck(:name)
  end
end