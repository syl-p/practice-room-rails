# frozen_string_literal: true

class MenuComponent < ViewComponent::Base
  renders_one :header
  renders_many :items, MenuItemComponent
  renders_many :dividers
end
