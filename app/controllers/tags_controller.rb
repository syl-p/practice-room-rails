class TagsController < ApplicationController
  def search
    return unless params[:pattern].present?
    @tags = Tag.where("name LIKE ?", "%#{params[:pattern]}%").limit(10)
  end
end
