# frozen_string_literal: true

class AlertComponent < ViewComponent::Base
  renders_one :title
  renders_one :body

  def initialize(variant: :default)
    @variant = variant
  end

  def alert_classes
    case @variant.to_sym
    when :default
      ""
    when :error, :danger, :alert, :destructive
      "toast-alert"
    when :success
      "toast-success"
    when :info
      "toast-primary"
    end
  end
end
