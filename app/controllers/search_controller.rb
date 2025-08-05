class SearchController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]

  def index
    @results = SearchService.call(params[:term])
  end

  def new
  end
end
