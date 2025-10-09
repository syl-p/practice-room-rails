class PracticesController < ApplicationController
  before_action :set_practice, only: %i[ show edit update destroy ]

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
    Current.user.practices << @practice

    redirect_to root_path, notice: "Practice was successfully created."
  end

  # PATCH/PUT /practices/1 or /practices/1.json
  def update
    respond_to do |format|
      if @practice.update(practice_params)
        format.html { redirect_to @practice, notice: "Practice was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practices/1 or /practices/1.json
  def destroy
    @practice.destroy!

    respond_to do |format|
      format.html { redirect_to practices_path, status: :see_other, notice: "Practice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def practice_params
      params.require(:practice).permit(:name, :description)
      raw_params = params.require(:practice).permit(:name, :description, :tag_ids)
      raw_params[:tag_ids] = raw_params[:tag_ids].to_s.split(",").reject(&:blank?)
      raw_params
    end
end
