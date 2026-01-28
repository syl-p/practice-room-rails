class Practices::PracticeEntriesController < ApplicationController
  before_action :set_practice
  before_action :set_activity, only: [ :create ]
  before_action :set_duration, only: [ :create ]
  before_action :set_practice_entry, only: [ :destroy ]

  def index
    session[:current_practice_id] = @practice.id

    @current_date = parse_date(params[:date]) || Date.today
    @start_at = @current_date.beginning_of_week
    @end_at = @current_date.end_of_week
    @practice_entries = @practice
                                   .practice_entries.at(@current_date.beginning_of_day, @current_date.end_of_day)
  end

  def create
    @practice_entry = PracticeEntry.new(
      activity: @activity,
      user: Current.user,
      duration: @duration,
      practice: @practice,
    )

    if @practice_entry.save
      flash[:success] = "Votre temps de pratique à été mise à jour."
    end
  end

  def destroy
    @practice_entry.destroy

    @remaining_for_day = PracticeEntry.today.exists? ? 1 : 0
    flash[:success] = "Votre temps de pratique à été mise à jour."
  end

  private
  def set_practice_entry
    @practice_entry = Current.user.practice_entries.find(params[:id])
  end

  def set_duration
    begin
      @duration = Integer(params[:duration])
      raise ArgumentError if @duration <= 0
    rescue ArgumentError, TypeError
      flash[:alert] = "Duration not valid."
      render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") and return
    end
  end

  def set_activity
    begin
      @activity = Activity.find(params[:activity_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Activity not found."
    end
  end

  def set_practice
    begin
      @practice = Practice.find(params[:practice_id]) || session[:current_practice_id]
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Practice not found."
    end
  end

  def parse_date(date_param)
    return nil if date_param.blank?

    Date.parse(date_param.to_s)
  rescue ArgumentError
    nil
  end
end
