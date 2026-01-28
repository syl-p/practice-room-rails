# frozen_string_literal: true

class DropdownComponent < ViewComponent::Base
  renders_one :trigger_btn
  renders_one :dropdown_menu

  def initialize(variant: :outline)
    @variant = variant
  end

  def variant_class_name
    [
      TailwindHelper::BTN_BASE_CLASSES,
      TailwindHelper::BUTTON_VARIANTS.fetch(@variant)
    ].compact.join(" ")
  end
end
