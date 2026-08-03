class SearchController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]

  def index
    search_service = SearchService.new(params[:term])
    @results = search_service.results
  end

  def new
  end
end
