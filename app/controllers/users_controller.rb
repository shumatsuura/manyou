class UsersController < ApplicationController
  before_action :set_user, only:[:show,:edit,:update]

  def new
    if logged_in?
      redirect_to tasks_path, notice: "既にログイン済みです。"
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id), notice: "Sign Upしました！"
    else
      render 'new'
    end
  end

  def show
    if logged_in?
      if current_user.id == params[:id].to_i
        threshold = DateTime.now + 1.day #期限直前の判定の閾値を設定（1日）
        @expired_tasks = @user.tasks.where('due <= ?', threshold).where("(status = ?) or (status = ?)", '未着手', '着手中')
        if @expired_tasks.count > 0
          number = @expired_tasks.count
          flash[:danger] = "期限切れ、期限直前のタスクが#{number}件あります。"
        end
      else
        redirect_to tasks_path, notice:"権限がありません。"
      end
    else
      redirect_to new_session_path, notice: "ログインしてください。"
    end
  end

  def edit
    if logged_in?
      if current_user.id == params[:id].to_i
      else
        redirect_to tasks_path, notice:"権限がありません。"
      end
    else
      redirect_to new_session_path, notice: "ログインしてください。"
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice:"ユーザー情報を更新しました。"
    else
      render ('edit')
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_picture)
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
