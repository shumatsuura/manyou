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
      render'new'
    end
  end

  def show
    if logged_in?
      if current_user.id == params[:id].to_i
        @user = User.find(params[:id])
      else
        redirect_to root_path, notice:"権限がありません"
      end
    else
      redirect_to root_path, notice: "ログインしてください。"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,:password, :password_confirmation)
  end

end
