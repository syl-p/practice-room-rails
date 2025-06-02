class ActivityPolicy < ApplicationPolicy
  def show?
    record.published? || (user&.id == record.user_id)
  end
end