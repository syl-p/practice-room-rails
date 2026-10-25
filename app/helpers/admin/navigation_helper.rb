# frozen_string_literal: true

module Admin
  module NavigationHelper
    # @param [String, Symbol] controller
    # @return [Boolean]
    def admin_nav_active?(controller)
      controller_name == controller.to_s
    end

    # @param [Boolean] active
    # @return [String]
    def admin_nav_link_classes(active)
      [
        "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
        (active ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-background hover:text-foreground")
      ].join(" ")
    end
  end
end
