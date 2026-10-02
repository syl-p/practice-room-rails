class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  layout "marketing"

  before_action :set_post, only: :show

  def index
    @posts = Post.published.includes(:user).recent
  end

  # Un brouillon n'existe pas pour le public : on renvoie un vrai 404 plutôt
  # qu'une redirection, histoire de ne pas laisser indexer une page vide.
  # cause: nil coupe le lien avec NotAuthorizedError, sinon le handler de
  # rescue_from le retrouve et redirige vers la home.
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
