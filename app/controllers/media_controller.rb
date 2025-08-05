class MediaController < ApplicationController
  allow_unauthenticated_access except: :create

  def index
    @media = Medium.where(user: Current.user)
  end

  def new
    @medium = Medium.new
  end

  def create
    @medium = Medium.new(user: Current.user)
    @medium.file.attach(params[:file])

    if @medium.save
      render json: @medium, status: 201
    else
      render json: { errors: @medium.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
