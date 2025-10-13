class PracticesController < ApplicationController
  before_action :set_practice, only: %i[ edit update destroy ]

  # GET /practices/new
  def new
    @practice = Practice.new
  end

  # GET /practices/1/edit
  def edit
  end

  # POST /practices or /practices.json
  def create
    @practice = Practice.new(practice_params)

    tags = params[:tag_labels].to_s.split(",").reject(&:blank?)
    if tags.present?
      @practice.tags = find_tags(tags)
    end

    Current.user.practices << @practice
    redirect_to @practice, flash: {success: "Practice was successfully created." }
  end

  # PATCH/PUT /practices/1 or /practices/1.json
  def update
    tags = params[:tag_labels].to_s.split(",").reject(&:blank?)
    if tags.present?
      @practice.tags = find_tags(tags)
    end

    if @practice.update(practice_params)
      redirect_to @practice, flash: {success: "Practice was successfully updated." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /practices/1 or /practices/1.json
  def destroy
    @practice.destroy!
    redirect_to root_path, status: :see_other, flash: {success: "Practice was successfully destroyed." }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def practice_params
      params.require(:practice).permit(:name, :description)
    end

  def find_tags(labels)
    Tag.where(name: labels)
  end
end
