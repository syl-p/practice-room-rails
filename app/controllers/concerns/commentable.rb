module Commentable
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include ApplicationHelper

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = Current.user
    @comment.commentable = @commentable
    @comment.parent_id = @parent&.id
    replace_target = @parent ? @parent : @commentable

    respond_to do |format|
      if @comment.save
        format.turbo_stream {
          render turbo_stream: turbo_stream
                                 .prepend("#{dom_id(@parent || @commentable)}_comments",
                                          partial: "comments/comment",
                                          locals: { comment: @comment, commentable: replace_target })
        }
        format.html {
          redirect_to @commentable
        }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(record_id_gen(@parent || @commentable, @comment),
                                                    partial: "comments/form",
                                                    locals: { comment: @comment, commentable: replace_target }
          )
        }
        format.html {
          redirect_to replace_target
        }
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
