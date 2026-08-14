# frozen_string_literal: true

class DayPickerComponent < ViewComponent::Base
  # @param [Practice] practice
  # @param [Date] current_date
  def initialize(practice:, current_date:)
    @practice = practice
    @current_date = current_date
    @start_at = @current_date.beginning_of_week
    @end_at = @current_date.end_of_week
    @practice_entries = @practice.practice_entries.at(@start_at, @end_at)
      .select("COALESCE(SUM(duration),0) as duration, created_at")
      .group("DATE(created_at)")
  end

  # @param [Date] day
  # @return [Boolean]
  def today?(day)
    day == Date.current
  end

  # @param [Date] day
  # @return [Boolean]
  def active?(day)
    day == @current_date
  end

  # @param [Date] day
  # @return [Boolean]
  def has_entries?(day)
    @practice_entries.select { |entry| entry.created_at.to_date == day }.any?
  end

  # @param [Date] day
  # @return [Number]
  def entries_duration_for(day)
    entry = @practice_entries.find { |entry| entry.created_at.to_date == day }
    entry ? entry.duration : 0
  end

  # @param [Date] day
  # @return [String]
  def day_classes(day)
    classes = "block text-center p-1 rounded-lg relative"
    classes += " border-2 border-primary" if active?(day)
    classes += " border" unless active?(day)
    classes += " shadow-lg bg-primary/75 text-secondary" if today?(day)
    classes
  end

  def previous_week
    @start_at - 1.week
  end

  def next_week
    @end_at + 1.week
  end

  # @param [Date] day
  # @return [String]
  def path_for(day)
    if day == Date.current
      Rails.application.routes.url_helpers.practice_path(@practice)
    else
      Rails.application.routes.url_helpers.practice_practice_entries_path(practice_id: @practice.id, date: day)
    end
  end
end
