class FollowsController < ApplicationController
  before_action :find_follow, only: [ :destroy ]
  before_action :find_user

  def create
    return unless authenticated?
    @follow = Follow.new
    @follow.follower = Current.user
    @follow.following = @user
    @follow.save
  end

  def destroy
    return :not_found unless @follow.present?
    @follow.destroy

    render :create
  end

  private
  def find_follow
    @follow = Current.user.follows_as_following.find_by(following_id: params[:id])
  end

  def find_user
    @user = User.find(params[:id])
  end
end
