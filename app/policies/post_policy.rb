class PostPolicy < ApplicationPolicy
  def show?
    record.published? || author?
  end

  def index?;     admin?; end
  def new?;       admin?; end
  def create?;    admin?; end
  def edit?;      admin?; end
  def update?;    admin?; end
  def destroy?;   admin?; end
  def publish?;   admin?; end
  def unpublish?; admin?; end

  private
    def admin?
      user&.admin?
    end

    def author?
      user.present? && user.id == record.user_id
    end
end
