# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, except: %i[index]
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Edited successfully'
      redirect_to @user
    else
      flash[:alert] = 'Unable to edit'
      render 'edit'
    end
  end

  def destroy
    return redirect_to users_path, alert: 'You cannot delete yourself!' if current_user == @user
    if @user.destroy
      flash[:notice] = 'Deleted successfully'
      redirect_to users_path
      return
    else
      flash[:alert] = 'Unable to delete'
    end
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end
end
