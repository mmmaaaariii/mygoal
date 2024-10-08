class Admin::PostCommentsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  
  def index
    @post_comments = PostComment.all
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    @post_comment.destroy
    redirect_to admin_post_comments_path, notice: 'コメントを削除しました'
  end
end