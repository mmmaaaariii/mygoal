class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def create
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = post.id
    comment.save
    redirect_to posts_path(post)
  end
  
  def destroy
    @post_comment&.destroy
    redirect_to post_path(params[:post_id])
  end
  
  private
  
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
  
  def correct_user
    @post_comment = current_user.post_comments.find_by_id(params[:id])
    redirect_to root_path unless @post_comment
  end
end
