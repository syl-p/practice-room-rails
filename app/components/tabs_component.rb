# frozen_string_literal: true

class TabsComponent < ViewComponent::Base
  attr_reader :default
  renders_many :tabs, TabComponent

  def initialize(default: 0)
    @default = default
  end
end
