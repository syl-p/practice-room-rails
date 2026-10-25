class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  layout "marketing"

  before_action :set_post, only: :show

  def index
    @posts = Post.published.includes(:user).recent
  end

  def show
    authorize! @post
  rescue NotAuthorizedError
    raise ActiveRecord::RecordNotFound, cause: nil
  end

  private
    def set_post
      @post = Post.find_by!(slug: params[:id])
    end
end
