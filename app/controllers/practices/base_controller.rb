# frozen_string_literal: true

class Practices::BaseController < ApplicationController
  before_action :set_practice

  private
  def set_practice
    @practice = Practice.find(params[:practice_id])
  end

  def set_stats
    service = Practices::PracticeEntriesService.new(
      user: Current.user,
      practice_id: @practice.id,
      start_at: Date.today.beginning_of_day,
      end_at: Date.today.end_of_day
    )
    @stats = {
      total_duration: service.total_duration,
      activities_count: service.activities_count
    }
  end
end
