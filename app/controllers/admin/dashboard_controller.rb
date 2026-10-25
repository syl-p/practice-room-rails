module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        users: User.count,
        new_users: User.where(created_at: 30.days.ago..).count,
        practices: Practice.count,
        activities: Activity.count,
        comments: Comment.count,
        published_posts: Post.published.count,
        draft_posts: Post.draft.count
      }

      @recent_posts = Post.includes(:user).order(created_at: :desc).limit(5)
    end
  end
end
