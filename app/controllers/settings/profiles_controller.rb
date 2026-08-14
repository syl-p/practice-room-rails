class Settings::ProfilesController < ApplicationController
  def edit
  end

  def update
    if params[:user][:avatar_removed] == "1"
      Current.user.avatar.purge
    end

    if Current.user.update(user_params)
      redirect_to edit_settings_profile_path, flash: {success: "Vos nouvelles informations ont été enregistrées !"}
    else
      Current.user.avatar.purge
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :bio, :username, :email_address)
  end
end
