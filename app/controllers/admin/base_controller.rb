module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :require_admin

    private
      def require_admin
        redirect_to root_path, alert: "Accès réservé aux administrateurs." unless Current.user&.admin?
      end
  end
end
