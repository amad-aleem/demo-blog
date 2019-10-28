class UserPolicy < ApplicationPolicy
  def index?
    @user.Admin?
  end

  def show?
    @user.Admin?
  end

  def edit?
    @user.Admin?
  end

  def update?
    @user.Admin?
  end

  def destroy?
    @user.Admin?
  end
end
