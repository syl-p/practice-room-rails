class MediaController < ApplicationController
  before_action :set_medium, only: [ :destroy ]

  def index
    @media = Medium.where(user: Current.user)
  end

  def create
    @medium = Medium.new(user: Current.user)
    @medium.file.attach(params[:file])

    if @medium.save
      respond_to do |format|
        format.turbo_stream
        format.json { render json: @medium, status: 200 }
      end
    else
      render json: { errors: @medium.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @medium.destroy!
  end

  private

  def set_medium
    @medium = Medium.find(params[:id])
  end
end
