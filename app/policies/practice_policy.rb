class PracticePolicy < ApplicationPolicy
  def attach?
    user&.id == record.user_id
  end

  def detach?
    user&.id == record.user_id
  end
end