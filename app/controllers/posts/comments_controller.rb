class Posts::CommentsController < ApplicationController
  layout "marketing"

  before_action :set_commentable
  include Commentable

  private
    def set_commentable
      @commentable = Post.find_by!(slug: params[:post_id])
      authorize!(@commentable, :show?)
    end
end
