module Commentable
  extend ActiveSupport::Concern

  def create
    @comment = Comment.new(comment_params)
    @comment.user = Current.user
    @comment.commentable = @commentable
    @comment.parent_id = @parent&.id

    if @comment.save
      redirect_to @commentable, notice: "Comment was successfully created."
    else
      flash.now[:alert] = "Failed to create comment."
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end