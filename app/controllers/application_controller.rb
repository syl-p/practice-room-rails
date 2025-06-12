class ApplicationController < ActionController::Base
  include Authentication
  include Authorized
  before_authorize :resume_session
  rescue_from NotAuthorizedError do |exception|
    redirect_to activities_url, alert: exception.message
  end

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
