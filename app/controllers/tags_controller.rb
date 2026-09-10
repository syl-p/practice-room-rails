class TagsController < ApplicationController
  def search
    @tags = if params[:pattern].present?
      Tag.where("name LIKE ?", "%#{params[:pattern]}%").limit(10)
    else
      Tag.none
    end
  end
end
