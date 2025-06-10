# frozen_string_literal: true

class AvatarComponent < ViewComponent::Base
  def initialize(user:, size: :md)
    @user = user
    @size = size
  end

  def initials
    @user.username[0]
  end

  def avatar_path
    url_for(@user.avatar) if @user.avatar.attached? && @user.avatar.blob.present?
  end

  def size_classes
    case @size
    when :xs
      "w-4 h-4"
    when :sm
      "w-4 h-4"
    when :md
      "w-8 h-8"
    when :lg
      "w-10 h-10"
    when :xl
      "w-12 h-12"
    end
  end
end
