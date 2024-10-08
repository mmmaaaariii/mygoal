class Public::UsersController < ApplicationController
  
  def show
    @user = User.find_by(id: params[:id])
    if @user
      @posts = @user.posts
    else
      redirect_to root_path, notice: "ユーザーが見つかりません"
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    user = current_user
    user.destroy
    redirect_to user_path(user)
  end

  
  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
  
end
