class RegistrationController < ApplicationController
  before_action :set_user
  allow_unauthenticated_access only: %i[new create]
  layout "guest", only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url
    else
      render :new,  status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:avatar_removed] == "1"
      @user.avatar.purge
    end

    if !params[:user][:password].blank?
      update_user_with_password
    else
      update_user_without_password
    end
  end

  private


  def update_user_with_password
    user_params.delete(:avatar_removed)
    if @user.update_with_password(user_params)
      redirect_to edit_registration_url, notice: "Vos informations ont été mises à jour."
    else
      render :edit
    end
  end

  def update_user_without_password
    user_params.delete(:avatar_removed)
    if @user.update_without_password(user_params)
      redirect_to edit_registration_url, notice: "Vos informations ont été mises à jour."
    else
      render :edit
    end
  end

  def set_user
    @user = Current.user
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :avatar, :bio, :username, :email_address)
  end
end
