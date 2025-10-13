class PagesController < ApplicationController
  allow_unauthenticated_access
  def home
    if authenticated?
      @practices = Current.user.cached_practices
      redirect_to new_practices_path unless @practices.present?
    else
      @activities = ActivitiesService.call(tag_ids: [], limit: 5)
    end
  end
end
