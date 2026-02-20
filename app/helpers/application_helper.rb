module ApplicationHelper
  def record_id_gen(*records, prefix: nil)
    records.map do |r|
      dom_id(r, prefix)
    end.join("_")
  end

  def display_time(t)
    Time.at(t).utc.strftime("%H:%M:%S")
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
