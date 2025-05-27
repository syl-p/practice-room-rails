module ApplicationHelper
  def display_time(t)
    Time.at(t).utc.strftime("%H:%M:%S")
  end
end
