class PagesController < ApplicationController
  allow_unauthenticated_access
  def home
    if authenticated?
      @practices = Current.user.cached_practices
      redirect_to new_practices_path unless @practices.present?
    else
      redirect_to new_session_path
    end
  end
end
