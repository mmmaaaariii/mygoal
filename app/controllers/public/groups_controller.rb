class Public::GroupsController < ApplicationController
    Message = Struct.new(:title, :message, keyword_init: true)
    before_action :authenticate_user!
    before_action :ensure_correct_user, only: [:edit, :update, :destroy]

    def index
      @post = Post.new
      @groups = Group.all
      @user = User.find(current_user.id)
    end

    def show
      @post = Post.new
      @group = Group.find(params[:id])

    end

    def new
      @group = Group.new
    end

    def create
      @group = Group.new(group_params)
      @group.owner_id = current_user.id
      if @group.save
        redirect_to groups_path
      else
        render 'new'
      end
    end

    def edit
    end

    def update
      if @group.update(group_params)
        redirect_to groups_path
      else
        render "edit"
      end
    end

    def destroy
      group = Group.find(params[:id])
      group.destroy
      redirect_to groups_path
    end

    def new_group_message
      @group = Group.find(params[:id])
    end

    def create_group_message
      @group = Group.find(params[:id])
      @message = Message.new(message_params.to_h)
      @group.users.each do |user|
       ContactMailer.send_group_message(user, @message).deliver_now!
      end
      flash[:notice] = "送信しました"
      redirect_to group_path(@group)
    end

    private

    def group_params
      params.require(:group).permit(:name, :introduction, :group_image)
    end

    def message_params
      params.require(:message).permit(:title, :message)
    end

    def ensure_correct_user
      @group = Group.find(params[:id])
      unless @group.owner_id == current_user.id
        redirect_to groups_path
      end
    end
end
