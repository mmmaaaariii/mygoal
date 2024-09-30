class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :toggle_status]

  def new
    @post = Post.new
  end

  #投稿データの保存
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def index
     @posts = Post.where(status: "published")
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end


  def edit
    @post = Post.find(params[:id])
  end


  def toggle_status
    @post.toggle_status!
    redirect_to @post, notice: 'Post was successfully updated.'
  end


  def update
    @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to @post
      else
        render :edit
      end
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
