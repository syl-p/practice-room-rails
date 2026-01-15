# frozen_string_literal: true

class TagComponent < ViewComponent::Base
  erb_template <<-ERB
    <%= content_tag @as, nil, class: [@default_classes, @tag_classes].join(' '), data: @data do %>
      <%= @label %>
    <% end %>
  ERB

  def initialize(label = "", data: "", href: nil, variant: :default, **options, &block)
    @label = label
    @data = data
    @href = href
    @variant = variant
    @options = options
    @block = block

    @default_classes = "chip"
    @as = @href ? :a : :span

    @tag_classes = case @variant.to_sym
    when :default
                     TailwindHelper::PRIMARY_CLASSES
    when :secondary
                     TailwindHelper::SECONDARY_CLASSES
    when :error, :danger, :alert, :destructive
                     TailwindHelper::DESTRUCTIVE_CLASSES
    when :outline
                     TailwindHelper::OUTLINE_CLASSES
    when :ghost
                     TailwindHelper::GHOST_CLASSES
    else
                     TailwindHelper::PRIMARY_CLASSES
    end
  end
end
