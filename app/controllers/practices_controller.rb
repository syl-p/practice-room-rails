class PracticesController < ApplicationController
  before_action :set_practice, only: %i[ show edit update destroy ]
  before_action :set_stats, only: [ :show ]

  def show
    redirect_to new_practice_path, flash: { error: "Veuillez créer une pratique" } unless @practice.present?
    session[:current_practice_id] = @practice.id
  end

  def new
    @practice = Practice.new
  end

  def edit
  end

  def create
    @practice = Practice.new(practice_params)

    tags = params[:tag_labels].to_s.split(",").reject(&:blank?)
    if tags.present?
      @practice.tags = find_or_create_tags(tags)
    end

    Current.user.practices << @practice
    redirect_to @practice, flash: { success: "Practice was successfully created." }
  end

  def update
    tags = params[:tag_labels].to_s.split(",").reject(&:blank?)
    if tags.present?
      @practice.tags = find_or_create_tags(tags)
    end

    if @practice.update(practice_params)
      redirect_to @practice, flash: { success: "Practice was successfully updated." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @practice.destroy!
    redirect_to root_path, status: :see_other, flash: { success: "Practice was successfully destroyed." }
  end

  private
    def set_practice
      @practice = Practice.find(params[:id])
    end

    def practice_params
      params.require(:practice).permit(:name, :description)
    end

    def find_or_create_tags(labels)
      labels.map { |name| Tag.find_or_create_by!(name: name) }
    end

    def set_stats
      current_date = Date.today
      practices_activities_service = PracticeEntriesService.new(
        user: Current.user,
        practice_id: @practice.id,
        start_at: current_date.beginning_of_day,
        end_at: current_date.end_of_day
      )

      @stats = {
        more_than_10_mn_today: practices_activities_service.more_than_10_mn_today?,
        have_3_exercises_today: practices_activities_service.have_3_exercises_today?
      }
    end
end
