class PracticedActivitiesService
  def initialize(user)
    @user = user
  end

  def practices_by_date(date)
    @user.practiced_activities.at(date)
  end
end
