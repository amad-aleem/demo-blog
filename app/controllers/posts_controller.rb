# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, except: %i[index new create]
  after_action :verify_authorized

  def index
    authorize Post
    @posts = if policy(Post).admin_or_moderator?
               Post.includes(:reports).recent
             else
               Post.published.includes(:reports).recent
             end
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:replies, :likes).order(created_at: :desc).where(comment_id: nil)
    if Like.find_by(user_id: current_user.id, likeable_id: @post.id, likeable_type: 'Post')
      @liked_post = true
    end
    if Report.find_by(user_id: current_user.id, reportable_id: @post.id, reportable_type: 'Post')
      @reported_post = true
    end
    @report = current_user.reports.new
  end

  def new
    @post = current_user.posts.new
    authorize @post
  end

  def create
    @post = current_user.posts.create(post_params)
    authorize @post
    if @post.save
      flash[:notice] = 'Added successfully'
      redirect_to user_post_path(current_user, @post)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = 'Edited successfully'
      redirect_to user_post_path(current_user, @post)
    else
      flash[:alert] = 'Unable to edit'
      render 'edit'
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = 'Deleted successfully'
      redirect_to user_posts_path(current_user)
      return
    else
      flash[:alert] = 'Unable to delete'
    end
    redirect_to user_post_path(current_user, @post)
  end

  def publish
    @post.update(published: true)
    redirect_to user_posts_path(current_user)
  end

  def unpublish
    @post.update(published: false)
    redirect_to user_posts_path(current_user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def set_post
    @post = Post.find(params[:id])
    authorize @post
  end
end
