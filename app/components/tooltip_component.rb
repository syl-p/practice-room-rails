# frozen_string_literal: true

class TooltipComponent < ViewComponent::Base
  erb_template <<-ERB
    <div class="absolute top-0 -right-1 -mt-1 -mr-1 group cursor-pointer">
      <%= content %>
      <span class="absolute <%= position_classes %> opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap bg-gray-800 text-white text-xs rounded p-1.5 z-10">
        <%= @tooltip %>
      </span>
    </div>
  ERB

  # @param [String] tooltip
  # @param [Symbol] position :top, :bottom, :left, :right
  def initialize(tooltip, position: nil)
    @tooltip = tooltip
    @position = position
  end

  def position_classes
    case @position
    when :top
      "top-full left-1/2 -translate-x-1/2 mt-2"
    when :bottom
      "bottom-full left-1/2 -translate-x-1/2 mb-2"
    when :left
      "top-1/2 -translate-y-1/2 right-full mr-2"
    when :right
      "top-1/2 -translate-y-1/2 left-full ml-2"
    else
      "top-full left-1/2 -translate-x-1/2 mt-2"
    end
  end
end
