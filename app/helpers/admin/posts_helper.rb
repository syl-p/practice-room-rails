# frozen_string_literal: true

module Admin
  module PostsHelper
    def admin_post_status_label(post)
      post.published? ? "Publié" : "Brouillon"
    end

    def admin_post_status_classes(post)
      if post.published?
        "bg-success/10 text-success"
      else
        "bg-muted text-muted-foreground"
      end
    end
  end
end
