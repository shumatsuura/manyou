class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authorized_user?, only:[:edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(groups_params)
    @group.user_id = current_user.id
    if @group.save
      redirect_to group_path(@group), notice: 'グループを作成しました。'
    else
      render 'new'
    end
  end

  def index
    @groups = Group.all
  end

  def show
    if not @group.members.ids.include?(current_user.id) || @group.user.id == current_user.id
      redirect_to groups_path, notice: '権限がありません。'
    end
    @members = @group.members
    @group_tasks = Task.where(user_id: @members.ids).where(group_id: params[:id]) + @group.user.tasks.where(group_id: params[:id])
  end

  def edit
  end

  def update
    if @group.update(groups_params)
      redirect_to group_path(@group), notice: 'グループを更新しました。'
    else
      render (edit)
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: 'グループを削除しました。'
  end

  private

  def groups_params
    params.require(:group).permit(:name,:description)
  end

  def set_group
    @group = Group.find_by(id: params[:id])
  end

  def authorized_user?
    if not logged_in?
      redirect_to new_session_path, notice:'ログインしてください。'
    elsif current_user.admin
    elsif current_user.groups.ids.include?(params[:id].to_i)
    else
      redirect_to groups_path, notice:'権限がありません。'
    end
  end

end
