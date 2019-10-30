# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.new
    @like.user_id = current_user.id
    @like.likeable_type = params[:model]
    @like.likeable_id = params[:id]
    if @like.save
      redirect_back(fallback_location: root_path)
    else
      @like.errors.full_messages.each do |msg|
        flash[:alert] = msg
      end
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @like = Like.find_by(user_id: params[:user_id], likeable_id: params[:id])
    if @like.destroy
      redirect_back(fallback_location: root_path)
    else
      @like.errors.full_messages.each do |msg|
        flash[:alert] = msg
      end
      redirect_back(fallback_location: root_path)
    end
  end
end
