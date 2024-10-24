class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :index, :new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    if params[:search]
      @posts = Post.search(params[:search])
    else
      @posts = Post.all
    end
  end

  def new
    @post = Post.new
  end

  #投稿データの保存
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿に成功しました。"
      redirect_to posts_path
    else
      flash[:notice] = "投稿に失敗しました。"
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "更新に成功しました。"
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
    params.require(:post).permit(:title, :content, :image)
  end

  def set_post
    @post = Post.find_by_id(params[:id] || params[:post_id])
  end
  
  def correct_user
    if @post&.user != current_user
      redirect_to root_path
    end
  end
end
