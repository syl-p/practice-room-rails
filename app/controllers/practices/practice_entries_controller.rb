class Practices::PracticeEntriesController < ApplicationController
  include CurrentPractice
  set_practice_id_param :practice_id

  before_action :set_activity, only: [ :create ]
  before_action :set_duration, only: [ :create ]
  before_action :set_practice_entry, only: [ :destroy ]

  def index
    session[:current_practice_id] = @practice.id
    @current_date = parse_date(params[:date]) || Date.today
    @practice_entries = @practice.practice_entries.at(@current_date.beginning_of_day, @current_date.end_of_day)
  end

  def create
    @practice_entry = PracticeEntry.new(
      activity: @activity,
      user: Current.user,
      duration: @duration,
      practice: @practice,
    )

    if @practice_entry.save
      set_stats
      flash[:success] = "Votre temps de pratique à été mise à jour."
    else
      flash.now[:error] = @practice_entry.errors.full_messages.to_sentence
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
    @duration = params[:duration]
  end

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def parse_date(date_param)
    return nil if date_param.blank?

    Date.parse(date_param.to_s)
  rescue ArgumentError
    nil
  end
end
