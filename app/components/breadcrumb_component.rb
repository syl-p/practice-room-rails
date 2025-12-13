# frozen_string_literal: true

class BreadcrumbComponent < ViewComponent::Base
  def initialize(links)
    @links = links
  end

  def home_path
    Rails.application.routes.url_helpers.root_path
  end
end
