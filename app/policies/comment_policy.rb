class CommentPolicy <  ApplicationPolicy
  def update?
    user&.id == record.user_id
  end

  def destroy?
    user&.id == record.user_id
  end
end
