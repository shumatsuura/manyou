class GroupTasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]
  before_action :authorized_user?, only:[:edit, :update, :destroy]
  before_action :authorized_user_for_new_show?, only:[:new,:show]

  def show

  end

  def new
    @task = Task.new
    @labels = current_user.labels
  end

  def create
    @task = current_user.tasks.build(tasks_params)
    if @task.save
      redirect_to task_path(@task), notice:"グループタスクを作成しました。"
    else
      @labels = current_user.labels
      render new_task_path
    end
  end

  def edit

    @labels = current_user.labels
  end

  def update
    if @task.update(tasks_params)
      redirect_to task_path(@task.id), notice:"グループタスクを編集しました。"
    else
      @labels = current_user.labels
      render edit_task_path(@task.id)
    end

  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice:"削除しました。"
  end

  private

  def tasks_params
    params.require(:task).permit(:name, :description, :due, :status, :priority, :group_id,label_ids: [])
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def authorized_user?
    if not logged_in?
      redirect_to new_session_path, notice:'ログインしてください。'
    # アドミンユーザーの場合
    elsif current_user.admin
    # 自分のタスクの場合
    elsif current_user.tasks.ids.include?(params[:id].to_i)
    else
      redirect_to group_path(params[:group_id]), notice:'権限がありません。'
    end
  end

  def authorized_user_for_new_show?
    if not logged_in?
      redirect_to new_session_path, notice:'ログインしてください。'
    # アドミンユーザーの場合
    elsif current_user.admin
    # 自分のタスクの場合
    elsif current_user.tasks.ids.include?(params[:id].to_i)
    # グループのメンバーの場合
    elsif current_user.joined_groups.ids.include?(params[:group_id].to_i)
    # グループ作成者の場合
    elsif current_user.groups.ids.include?(params[:group_id].to_i)
    else
      redirect_to group_path(params[:group_id]), notice:'権限がありません。'
    end
  end
end
