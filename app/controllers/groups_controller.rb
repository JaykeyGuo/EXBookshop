class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 10)
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit

  end

  def update

    if @group.update(group_params)
      redirect_to groups_path, notice: "编辑成功"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:alert] = "讨论组已删除"
    redirect_to groups_path
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "成功加入此讨论版"
    else
      flash[:warning] = "你已是本讨论版成员"
    end
    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:warning] = "已退出讨论版"
    else
      flash[:alert] = "您不是本讨论版成员"
    end
    redirect_to group_path(@group)
  end

  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "这不是你的讨论版！"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
