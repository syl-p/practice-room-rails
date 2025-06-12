class SearchService < ApplicationService
  def call(pattern = "")
    [] if pattern.blank?


  end
end
