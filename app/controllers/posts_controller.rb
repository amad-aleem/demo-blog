class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.recent
  end

  def show
    @comment = Comment.new
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:replies).order(created_at: :desc).where(comment_id: nil)
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.create(post_params)
    if @post.save
      flash[:notice] = 'Added successfully'
      redirect_to user_post_path(current_user, @post)
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

		if @post.update(post_params)
      flash[:notice] = 'Edited successfully'
			redirect_to user_post_path(current_user, @post)
		else
      flash[:alert] = 'Unable to edit'
			render 'edit'
		end
  end

  def destroy
    @post = Post.find(params[:id])
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
    @post = Post.find(params[:id])
    @post.update(published: true)
    redirect_to user_posts_path(current_user)
  end
  
  def unpublish
    @post = Post.find(params[:id])
    @post.update(published: false)
    redirect_to user_posts_path(current_user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
