class Practices::PracticeEntriesService
  attr_reader :practice_entries

  # @param [User] user
  # @param [Integer] practice_id
  # @param [Date] start_at
  # @param [Date] end_at
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

  def have_3_activities_today?
    activity_count = @practice_entries.group(:activity_id).count
    {
      state: activity_count.keys.size,
      goal: 3
    }
  end
end
