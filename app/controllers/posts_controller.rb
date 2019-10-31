# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, except: %i[index new create]
  after_action :verify_authorized

  def index
    authorize Post
    @posts = policy(Post).index?
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:replies, :likes, :user).order(created_at: :desc).with_no_replies
    if @post.likes.any?
      @liked_post = true
    end
    if @post.reports.any?
      @reported_post = true
    end
    @report = current_user.reports.new
  end

  def new
    @post = current_user.posts.new
    authorize @post
  end

  def create
    @post = current_user.posts.new(post_params)
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
      flash[:notice] = 'Updated successfully'
      redirect_to user_post_path(current_user, @post)
    else
      flash[:alert] = @post.errors.full_messages.join('\n')
      render 'edit'
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = 'Deleted successfully'
      return redirect_to user_posts_path(current_user)
    else
      flash[:alert] = @post.errors.full_messages.join('\n')
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
