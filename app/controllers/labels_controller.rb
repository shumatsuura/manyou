class LabelsController < ApplicationController

  before_action :set_label, only:[:show, :edit, :update, :destroy]

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(labels_params)
    @label.user_id = current_user.id
    if @label.save
      redirect_to user_path(@label.user.id), notice:"ラベルが登録されました。"
    else
      render 'new'
    end
  end

  def edit
    if not logged_in?
      redirect_to root_path, notice: "ログインしてください。"
    else
      if not current_user.label_ids.include?(params[:id].to_i)
        redirect_to tasks_path, notice: "権限がありません。"
      end
    end
  end

  def update
    if @label.update(labels_params)
      redirect_to user_path(@label.user.id), notice:"ラベルを編集しました。"
    else
      render 'edit'
    end
  end

  def destroy
    @label.destroy
    redirect_to user_path(@label.user.id), notice:"削除しました。"
  end

  private

  def labels_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = Label.find_by(id: params[:id])
  end


end
