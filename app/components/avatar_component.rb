# frozen_string_literal: true

class AvatarComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def initials
    @user.username[0]
  end
end
