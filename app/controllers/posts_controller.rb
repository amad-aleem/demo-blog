class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:reports).recent
  end

  def show
    @comment = Comment.new
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:replies, :likes).order(created_at: :desc).where(comment_id: nil)
    @liked_post = true if Like.find_by(user_id: current_user.id, likeable_id: @post.id, likeable_type: 'Post')
    @reported_post = true if Report.find_by(user_id: current_user.id, reportable_id: @post.id, reportable_type: 'Post')
    @report = current_user.reports.new
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
