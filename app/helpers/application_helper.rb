module ApplicationHelper
  def record_id_gen(*records, prefix: nil)
    records.map do |r|
      dom_id(r, prefix)
    end.join("_")
  end

  def display_time(t)
    Time.at(t).utc.strftime("%H:%M:%S")
  end
end
