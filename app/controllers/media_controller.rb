class MediaController < ApplicationController
  def index
    @media = Medium.all
  end

  def new
    @medium = Medium.new
  end

  def create
    @medium = Medium.new(medium_params)
    if @medium.save
      redirect_to media_path, flash: { success: 'Medium Saved!' }
    else
      render 'new', flash: { error: 'Error!' }
    end
  end

  private
  def medium_params
    params.expect(medium: [:file])
  end
end
