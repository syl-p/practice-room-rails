# frozen_string_literal: true

class DonutStatComponent < ViewComponent::Base
  def initialize(state:, goal:, label_title:, label_subtitle:)
    @state = state
    @goal = goal
    @label_title = label_title
    @label_subtitle = label_subtitle
  end

  private

  attr_reader :state, :goal, :label_title, :label_subtitle

  def radius
    30
  end

  def stroke
    5
  end

  def normalized_radius
    radius - stroke / 2.0
  end

  def circumference
    normalized_radius * 2 * Math::PI
  end

  def progress
    (state > goal ? goal : state) * 100 / goal
  end

  def stroke_dash_offset
    circumference - (progress / 100.0) * circumference
  end

  def color_classes
    progress < 100 ? "text-blue-700" : "text-green-500"
  end
end
