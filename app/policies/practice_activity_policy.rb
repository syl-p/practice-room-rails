class PracticeActivityPolicy < ApplicationPolicy
  def destroy?
    user&.id == record.practice.user_id
  end
end
