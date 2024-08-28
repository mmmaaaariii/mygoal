class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :toggle_status]
  
  def new
    @post = Post.new
  end
  
  #投稿データの保存
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to posts_path
  end

  def index
     @post = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
    
  end
  
  def toggle_status
    @post.toggle_status!
    redirect_to @post, notice: 'Post was successfully updated.'
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end


  private
  
  def post_params
    params.require(:post).permit(:title, :content, :image, :status)
  end
  
  def set_post
    @post = Post.find(params[:id] || params[:post_id])
  end
  
end
