class PagesController < ApplicationController
  allow_unauthenticated_access
  def home
    if authenticated?
        @practices = Current.user.cached_practices
    end
  end
end
