class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]
  PER =20

  def index
    @tasks = Task.all.order(created_at: "DESC").page(params[:page]).per(PER)

    search_function
    sort_function(@tasks)
  end

  def search_function
    name_search_keyword = params[:name_search]
    status_search_keyword = params[:status_search]

    if name_search_keyword.present? && status_search_keyword.present?
      @tasks = Task.search_by_name_and_status(name_search_keyword,status_search_keyword).page(params[:page]).per(PER)
    elsif name_search_keyword.present? && status_search_keyword.blank?
      @tasks = Task.search_by_name(name_search_keyword).page(params[:page]).per(PER)
    elsif name_search_keyword.blank? && status_search_keyword.present?
      @tasks = Task.search_by_status(status_search_keyword).page(params[:page]).per(PER)
    end
  end

  def sort_function(tasks)
    #検索実行前のケース
    if params[:sort] == "due_ASC"
      @tasks = Task.all.order(due: "ASC").page(params[:page]).per(PER)
    elsif params[:sort] == "due_DESC"
      @tasks = Task.all.order(due: "DESC").page(params[:page]).per(PER)
    elsif params[:sort] == "priority_ASC"
      @tasks = Task.all.order(priority: "ASC").page(params[:page]).per(PER)
    elsif params[:sort] == "priority_DESC"
      @tasks = Task.all.order(priority: "DESC").page(params[:page]).per(PER)
    elsif params[:sort] == "created_at_DESC"
      @tasks = Task.all.order(created_at: "ASC").page(params[:page]).per(PER)
    elsif params[:sort] == "created_at_DESC"
      @tasks = Task.all.order(created_at: "DESC").page(params[:page]).per(PER)
    end

    #検索実行後のケース
    if params[:commit]
      if params[:commit].include?("due_ASC")
        @tasks = tasks.order(due: "ASC").page(params[:page]).per(PER)
      elsif params[:commit].include?("due_DESC")
        @tasks = tasks.order(due: "DESC").page(params[:page]).per(PER)
      elsif params[:commit].include?("priority_ASC")
        @tasks = tasks.order(priority: "ASC").page(params[:page]).per(PER)
      elsif params[:commit].include?("priority_DESC")
        @tasks = tasks.order(priority: "DESC").page(params[:page]).per(PER)
      elsif params[:commit].include?("created_at_DESC")
        @tasks = tasks.order(created_at: "ASC").page(params[:page]).per(PER)
      elsif params[:commit].include?("created_at_DESC")
        @tasks = tasks.order(created_at: "DESC").page(params[:page]).per(PER)
      end
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
    params.require(:task).permit(:name,:description,:due,:status,:priority)
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

end
