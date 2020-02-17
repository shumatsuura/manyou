class Admin::UsersController < ApplicationController
  before_action :admin_user?

  PER = 20

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user.id), notice: "ユーザーを作成しました。"
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
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id), notice: "更新しました。"
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice:"削除しました。"
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,:password, :password_confirmation,:admin, :profile_picture)
  end

  def admin_user?
    if logged_in? == false
      redirect_to new_session_path, notice: "ログインしてください。"
    elsif current_user.admin == false

      redirect_to tasks_path, notice: "権限がありません。"
    end
  end

end
