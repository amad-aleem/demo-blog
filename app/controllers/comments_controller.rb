# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create]

  def create
    @comment = @post.comments.create(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      @comment.errors.full_messages.each do |msg|
        flash[:alert] = msg
      end
      redirect_back(fallback_location: @post)
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id, :comment_id)
  end
end
