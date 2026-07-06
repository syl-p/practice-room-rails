# frozen_string_literal: true

class MenuItemComponent < ViewComponent::Base
  def initialize(href: nil, method: nil, **html_options)
    @href = href
    @method = method
    @html_options = html_options
  end

  def link?
    @href.present? && @method.nil?
  end

  def button?
    @method.present?
  end
end
