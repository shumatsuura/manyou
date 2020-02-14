class UsersController < ApplicationController
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
        @user = User.find(params[:id])
        threshold = DateTime.now + 1.day
        @expired_tasks = @user.tasks.where('due <= ?', threshold).where("(status = ?) or (status = ?)", '未着手', '着手中')
      else
        redirect_to tasks_path, notice:"権限がありません。"
      end
    else
      redirect_to new_session_path, notice: "ログインしてください。"
    end

    if @expired_tasks.count > 0
      number = @expired_tasks.count
      flash[:danger] = "期限切れ、期限直前のタスクが#{number}件あります。"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
