class CommentPolicy <  ApplicationPolicy
  def update?
    user&.id == record.user_id
  end

  def delete?
    user&.id == record.user_id
  end
end
