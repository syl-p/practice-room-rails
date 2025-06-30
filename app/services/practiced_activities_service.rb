class PracticedActivitiesService < ApplicationService
  def initialize(user: , start_at: , end_at:)
    @user = user
    @start_at = start_at
    @end_at = end_at
  end

  def more_than_10_mn_today?
    practice_time = @user.practiced_activities.at(@start_at, @end_at).sum(:duration)
    {
      state: practice_time,
      goal: 10.minutes
    }
  end

  def have_3_exercises_today?
    count = @user.practiced_activities.at(@start_at, @end_at).count
    {
      state: count,
      goal: 3,
    }
  end
end
