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
