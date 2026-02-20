class Practices::ProgressionController < ApplicationController
  before_action :set_practice, only: [ :index ]
  before_action :set_stats, only: [ :index ]

  def index
  end

  private
  def set_practice
    @practice = Practice.find(params[:practice_id])
  end

  def set_stats
    tags_with_duration = Tag.for_practice_with_duration(@practice.id).order("duration DESC")
    @stats = {
      tags_with_duration:
    }
  end
end
