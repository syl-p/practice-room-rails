class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[home about contact]
  layout "marketing"

  def home
    if authenticated?
      @practices = Current.user.cached_practices
      redirect_to new_practices_path unless @practices.present?
    end
  end

  def about; end

  def contact; end
end
