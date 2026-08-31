class Settings::PasswordsController < ApplicationController
  def edit
  end

  def update
    if Current.user.update(user_params)
      redirect_to edit_settings_password_path, flash: { success: "Mot de passe changé !" }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [ :password_challenge, :password, :password_confirmation ])
          .with_defaults(password_challenge: "")
  end
end
