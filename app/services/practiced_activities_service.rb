class PracticedActivitiesService < ApplicationService
  attr_reader :practiced_activities

  def initialize(user:, practice_id:, start_at:, end_at:)
    @user = user
    @start_at = start_at
    @end_at = end_at
    @practiced_activities = @user.practiced_activities.at(@start_at, @end_at)
                                                      .where(practice_id: )
  end

  def more_than_10_mn_today?
    practice_time = @practiced_activities.sum(:duration)
    {
      state: practice_time,
      goal: 10.minutes
    }
  end

  def have_3_exercises_today?
    count = @practiced_activities.count
    {
      state: count,
      goal: 3
    }
  end
end
