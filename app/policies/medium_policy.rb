class MediumPolicy < ApplicationPolicy
  def destroy?
    user&.id == record.user_id
  end
end
