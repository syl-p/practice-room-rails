module Admin
  class PostsController < BaseController
    before_action :set_post, only: %i[edit update destroy publish unpublish]

    def index
      authorize! Post.new

      @status = params[:status].to_s
      @search = params[:search].to_s.strip

      @posts = Post.includes(:user).order(created_at: :desc)

      @posts = @posts.where(status: @status) if Post.statuses.key?(@status)

      if @search.present?
        @posts = @posts.where("posts.title LIKE ?", "%#{Post.sanitize_sql_like(@search)}%")
      end
    end

    def new
      @post = Post.new

      authorize! @post
    end

    def create
      @post = Post.new(post_params)
      @post.user = Current.user

      authorize! @post

      if @post.save
        redirect_to edit_admin_post_path(@post), flash: { success: "Article créé." }
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize! @post
    end

    def update
      authorize! @post

      if @post.update(post_params)
        redirect_to edit_admin_post_path(@post), flash: { success: "Article mis à jour." }
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize! @post

      @post.destroy!

      redirect_to admin_posts_path, status: :see_other, flash: { success: "Article supprimé." }
    end

    def publish
      authorize! @post

      @post.update!(status: :published)

      redirect_to admin_posts_path, flash: { success: "Article publié." }
    end

    def unpublish
      authorize! @post

      @post.update!(status: :draft)

      redirect_to admin_posts_path, flash: { success: "Article repassé en brouillon." }
    end

    private
      def set_post
        @post = Post.find_by!(slug: params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :excerpt, :content, :meta_description, :cover, :status)
      end
  end
end
