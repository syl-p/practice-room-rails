module ApplicationHelper
  def record_id_gen(*records, prefix: nil)
    records.map do |r|
      dom_id(r, prefix)
    end.join("_")
  end

  def display_time(t)
    Time.at(t).utc.strftime("%H:%M:%S")
  end

  def human_duration(seconds)
    if seconds >= 3600
      hours = seconds / 3600
      "#{hours} heure#{'s' unless hours == 1}"
    elsif seconds >= 60
      minutes = seconds / 60
      "#{minutes} minute#{'s' unless minutes == 1}"
    else
      "#{seconds} seconde#{'s' unless seconds == 1}"
    end
  end

  def human_duration_short(seconds)
    return "0 min" if seconds < 60

    if seconds >= 3600
      hours = seconds / 3600
      minutes = (seconds % 3600) / 60
      minutes.zero? ? "#{hours} h" : "#{hours} h #{minutes} min"
    else
      "#{seconds / 60} min"
    end
  end

  # Rerender flash messages in ui with turbo stream
  def turbo_flash_stream
    safe_join(
      flash.map do |type, message|
        flash_type = type
        flash_message = message
        turbo_stream.append :flash do
          render partial: "shared/flash", locals: { type: flash_type, message: flash_message }
        end
      end
    )
  end
end
