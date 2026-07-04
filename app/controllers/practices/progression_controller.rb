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
    practice_activities_service = Practices::ActivitiesService.new(@practice)
    @stats = {
      tags_with_duration:,
      top_practiced_activities: practice_activities_service.top_practiced_activities(5)
    }
  end
end
