# frozen_string_literal: true

class DropdownComponent < ViewComponent::Base
  renders_one :trigger_btn
  renders_one :dropdown_menu

  def initialize(variant: :outline, menu_classes: "", menu_position: :down)
    @variant = variant
    @menu_classes = menu_classes
    @menu_position = menu_position
  end

  def position_classes
    @menu_position == :up ? "top-auto bottom-full mb-2" : "mt-4"
  end

  def variant_class_name
    [
      TailwindHelper::BTN_BASE_CLASSES,
      TailwindHelper::BUTTON_VARIANTS.fetch(@variant)
    ].compact.join(" ")
  end
end
