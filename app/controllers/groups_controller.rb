class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

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
  end

  def edit
  end

  private

  def groups_params
    params.require(:group).permit(:name,:description)
  end

  def set_group
    @group = Group.find_by(id: params[:id])
  end


end
