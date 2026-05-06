# frozen_string_literal: true

class TabComponent < ViewComponent::Base
  attr_reader :id, :label, :button_class

  def initialize(id:, label:, button_class: "")
    @id = id
    @label = label
    @button_class = button_class
  end
end
