# frozen_string_literal: true

class ProductPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    !user.admin?
  end

  def show?
    !user.admin?
  end

  def create?
    !user.admin?
  end

  def update?
    !user.admin? && record.user_id == user&.id
  end

  def destroy?
    !user.admin? && record.user_id == user&.id
  end

  def transfer_from?
    !user.admin? && record.user_id == user&.id
  end

  def transfer_to?
    !user.admin? && record.user_id != user&.id
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise Pundit::NotAuthorizedError if user.admin?

      scope.all
    end

    private

    attr_reader :user, :scope
  end
end
