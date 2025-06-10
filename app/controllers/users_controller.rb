class UsersController < ApplicationController
  allow_unauthenticated_access only: :show
  def show
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
