class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]
  before_action :authorized_user?, only:[:show, :edit, :update, :destroy]

  PER =20

  def index
    if logged_in?
      @tasks = Task.where(user_id: current_user.id).order(created_at: "DESC").page(params[:page]).per(PER)

      search_function
      sort_function(@tasks)
    else
      redirect_to new_session_path, notice: "ログインしてください。"
    end
  end

  def search_function
    name_search_keyword = params[:name_search]
    status_search_keyword = params[:status_search]
    label_search_keyword = params[:label_search]

    if name_search_keyword.present? or status_search_keyword.present? or label_search_keyword.present?
      @tasks = Task.where(user_id: current_user.id)
    end

    if name_search_keyword.present?
      @tasks = @tasks.search_by_name(name_search_keyword)
    end

    if status_search_keyword.present?
      @tasks = @tasks.search_by_status(status_search_keyword)
    end

    if label_search_keyword.present?
      @tasks = @tasks.search_by_label(label_search_keyword)
    end

    if name_search_keyword.present? or status_search_keyword.present? or label_search_keyword.present?
      @tasks = @tasks.page(params[:page]).per(PER)
    end
  end

  def sort_function(tasks)
    #検索実行前のケース
    if params[:sort] == "due_ASC"
      @tasks = Task.where(user_id: current_user.id).order(due: "ASC").page(params[:page]).per(PER)
    elsif params[:sort] == "due_DESC"
      @tasks = Task.where(user_id: current_user.id).order(due: "DESC").page(params[:page]).per(PER)
    elsif params[:sort] == "priority_ASC"
      @tasks = Task.where(user_id: current_user.id).order(priority: "ASC").page(params[:page]).per(PER)
    elsif params[:sort] == "priority_DESC"
      @tasks = Task.where(user_id: current_user.id).order(priority: "DESC").page(params[:page]).per(PER)
    elsif params[:sort] == "created_at_DESC"
      @tasks = Task.where(user_id: current_user.id).order(created_at: "ASC").page(params[:page]).per(PER)
    elsif params[:sort] == "created_at_DESC"
      @tasks = Task.where(user_id: current_user.id).order(created_at: "DESC").page(params[:page]).per(PER)
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
    @labels = current_user.labels
  end

  def create
    @task = Task.new(tasks_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to task_path(@task), notice:"タスクが登録されました。"
    else
      render 'new'
    end
  end

  def edit
    @labels = current_user.labels

  end

  def update
    if @task.update(tasks_params)
      redirect_to task_path(@task.id), notice:"タスクを編集しました。"
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
    params.require(:task).permit(:name,:description,:due,:status,:priority,label_ids: [])
  end

  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def authorized_user?
    if not logged_in?
      redirect_to new_session_path, notice:'ログインしてください。'
    elsif current_user.admin
    elsif current_user.tasks.ids.include?(params[:id].to_i)
    else
      redirect_to tasks_path, notice:'権限がありません。'
    end
  end
end
