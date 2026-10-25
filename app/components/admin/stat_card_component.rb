# frozen_string_literal: true

module Admin
  class StatCardComponent < ViewComponent::Base
    def initialize(label:, value:, icon_name: nil, hint: nil)
      @label = label
      @value = value
      @icon_name = icon_name
      @hint = hint
    end

    private

    attr_reader :label, :value, :icon_name, :hint
  end
end
