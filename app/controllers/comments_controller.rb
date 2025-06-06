class CommentsController < ApplicationController
  allow_unauthenticated_access only: [ :show ]
  before_action :set_comment, only: [ :show, :edit, :update, :destroy ]

  def show
  end

  def edit
  end

  def update
    authorize! @comment, :update?

    if @comment.update(comment_params)
      redirect_to @comment, notice: "Comment was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable, notice: "Comment was successfully destroyed."
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end
end
