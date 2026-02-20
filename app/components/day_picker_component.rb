# frozen_string_literal: true

class DayPickerComponent < ViewComponent::Base
  # @param [Practice] practice
  # @param [Date] current_date
  def initialize(practice:, current_date:)
    @practice = practice
    @practice_entries = @practice.practice_entries.where(date: @start_at..@end_at)
    @current_date = current_date

    @start_at = @current_date.beginning_of_week
    @end_at = @current_date.end_of_week
  end

  # @param [Date] day
  def today?(day)
    day == Date.current
  end

  # @param [Date] day
  def active?(day)
    day == @current_date
  end

  # @param [Date] day
  def has_entries?(day)
    @practice_entries.select { |entry| entry.created_at.to_date == day }.any?
  end

  def day_classes(day)
    classes = "block text-center p-1 rounded-lg relative"
    classes += " border-2" if active?(day)
    classes += " border" unless active?(day)
    classes += " shadow-lg bg-primary text-white" if today?(day)
    classes
  end

  # @param [Date] day
  def path_for(day)
    if day == Date.current
      Rails.application.routes.url_helpers.practice_path(@practice)
    else
      Rails.application.routes.url_helpers.practice_practice_entries_path(practice_id: @practice.id, date: day)
    end
  end
end
