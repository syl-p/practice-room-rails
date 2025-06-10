# frozen_string_literal: true

class DropdownComponent < ViewComponent::Base
  renders_one :trigger_btn
  renders_one :dropdown_menu

  def initialize(variant: :default)
    @variant = variant
  end

  def variant_class_name
    button_classes = TailwindHelper::BTN_BASE_CLASSES
    variant_classes = case @variant.to_sym
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
                      end

    "#{button_classes} #{variant_classes}"
  end
end
