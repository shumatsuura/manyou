class GroupRelationsController < ApplicationController
  def create
    if current_user.id != Group.find_by(id: params[:group_id]).user_id
      current_user.group_relations.create(group_id: params[:group_id])
      redirect_to groups_path
    else
      redirect_to groups_path, notice: 'あなたはグループの管理者です。'
    end
  end

  def destroy
    current_user.group_relations.find_by(id: params[:id]).destroy
    redirect_to groups_path
  end
end
