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

  # @return [Numeric]
  def total_duration
    @practice_entries.sum(:duration)
  end

  # @return [Numeric]
  def activities_count
    @practice_entries.group(:activity_id).count.keys.size
  end
end
