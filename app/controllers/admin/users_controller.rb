class Admin::UsersController < ApplicationController
  before_action :admin_user?

  PER = 20

  def new
    @user = User.new

  end

  def create
    @user = User.new(user_params)
    if @user.save
          redirect_to user_path(@user.id), notice: "Sign Upしました！"
    else
      render'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all.page(params[:page]).per(PER)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to admin_users_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,:password, :password_confirmation,:admin)
  end

  def admin_user?
    if logged_in? == false
      redirect_to new_session_path, notice: "ログインしてください。"
    elsif current_user.admin == false
      redirect_to new_session_path, notice: "権限がありません。"
    end
  end

end
