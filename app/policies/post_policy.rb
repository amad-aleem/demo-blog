# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  def index?
    if self.admin_or_moderator?
      return Post.includes(:reports, :user).recent
    else
      return Post.published.includes(:reports, :user).recent
    end
  end

  def show?
    return true if @user || admin_or_moderator?
  end

  def new?
    return true if @user
  end

  def create?
    return true if @user
  end

  def edit?
    return true if @user && (is_author? || admin_or_moderator?)
  end

  def update?
    return true if @user && (is_author? || admin_or_moderator?)
  end

  def destroy?
    return true if @user && (is_author? || admin_or_moderator?)
  end

  def publish?
    return true if @user && admin_or_moderator?
  end

  def unpublish?
    return true if @user && admin_or_moderator?
  end

  def admin_or_moderator?
    return true if @user && (@user.Admin? || @user.Moderator?)
  end

  def is_author?
    return true if @user && (@user == post.user)
  end

  private

  def post
    record
  end
end
