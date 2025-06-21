class Activities::CommentsController < ApplicationController
  allow_unauthenticated_access only: [ :index ]
  before_action :set_commentable
  include Commentable

  def index
    @comments = @commentable.comments.where(parent_id: nil).order(created_at: :desc)
  end

  private
  def set_commentable
    @commentable = Activity.find(params[:activity_id])
  end
end
