class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]

  def index
    name_search_keyword = params[:name_search]
    status_search_keyword = params[:status_search]
    @tasks = Task.all

    if name_search_keyword.present? && status_search_keyword.present?
      @tasks = Task.search_by_name_and_status(name_search_keyword,status_search_keyword)
    elsif name_search_keyword.present? && status_search_keyword.blank?
      @tasks = Task.search_by_name(name_search_keyword)
    elsif name_search_keyword.blank? && status_search_keyword.present?
      @tasks = Task.search_by_status(status_search_keyword)
    end

    if params[:sort] == "due_ASC"
      @tasks = @tasks.order(due: "ASC")
    elsif params[:sort] == "due_DESC"
      @tasks = @tasks.order(due: "DESC")
    elsif params[:sort] == "created_at_DESC"
      @tasks = @tasks.order(created_at: "ASC")
    elsif params[:sort] == "created_at_DESC"
      @tasks = @tasks.order(created_at: "DESC")
    end

  end



  def show

  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(tasks_params)
    if @task.save
      redirect_to task_path(@task), notice:"タスクが登録されました。"
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @task.update(tasks_params)
      redirect_to tasks_path, notice:"タスクを編集しました。"
    else
      render 'edit'
    end

  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice:"削除しました。"
  end

  private

  def tasks_params
    params.require(:task).permit(:name,:description,:due,:status)
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

end
