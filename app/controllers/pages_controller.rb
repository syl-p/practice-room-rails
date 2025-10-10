class PagesController < ApplicationController
  allow_unauthenticated_access
  def home
    if authenticated?
      @practices = Current.user.cached_practices
      if @practices.size == 0
        redirect_to new_practices_path
      end
    else
      @activities = ActivitiesService.call(tag_ids: [], limit: 5)
    end
  end
end
