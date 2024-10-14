class Public::GroupUsersController < ApplicationController
    before_action :authenticate_user!
    
  def create
    group = Group.find(params[:group_id])
    current_user.group_users.find_or_create_by(group_id: group.id)
    redirect_back(fallback_location: root_url)
  end

  def destroy
    group = Group.find(params[:group_id])
    group_user = current_user.group_users.find_by(group_id: group.id)
    group_user.destroy if group_user
    redirect_back(fallback_location: root_url)
  end
end