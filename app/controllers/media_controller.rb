class MediaController < ApplicationController
  before_action :set_medium, only: [ :destroy ]

  def index
    @media = Medium.where(user: Current.user)
  end

  def create
    @medium = Medium.new(user: Current.user)
    @medium.file.attach(params[:file])

    if @medium.save
      render json: @medium
    else
      render json: { errors: @medium.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @medium.destroy!

    respond_to do |format|
      format.html { redirect_to media_path, status: :see_other, notice: "Media supprimé !" }
      format.json { head :no_content }
    end
  end

  private

  def set_medium
    @medium = Medium.find(params[:id])
  end
end
