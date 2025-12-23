class PracticeEntriesService < ApplicationService
  attr_reader :practice_entries

  def initialize(user:, practice_id:, start_at:, end_at:)
    @user = user
    @start_at = start_at
    @end_at = end_at
    @practice_entries = @user.practice_entries.at(@start_at, @end_at)
                                                      .where(practice_id:)
  end

  def more_than_10_mn_today?
    practice_time = @practice_entries.sum(:duration)
    {
      state: practice_time,
      goal: 10.minutes
    }
  end

  def have_3_exercises_today?
    count = @practice_entries.count
    {
      state: count,
      goal: 3
    }
  end
end
