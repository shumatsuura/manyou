require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'バリデーション' do
    it 'ユーザーが空だとバリデーションが通らない' do
      label = FactoryBot.build(:label, name: '')
      expect(label).not_to be_valid
    end

    it '名前が空だとバリデーションが通らない' do
      label = FactoryBot.build(:label, user_id: '')
      expect(label).not_to be_valid
    end

    it 'ユーザーと名前があればバリデーションが通る' do
      label = FactoryBot.build(:label)
      expect(label).to be_valid
    end
  end

  describe 'アソシエーションの操作' do
    context 'アソシエーション作成' do
      it 'ユーザとのアソシエーションでラベルを作成できる' do
        user = FactoryBot.create(:user)
        label = user.labels.build(name:"sample")
        expect(label).to be_valid
      end

      it 'タスクとのアソシエーションでラベルを作成できる' do
        user = FactoryBot.create(:user)
        task = FactoryBot.create(:task, user_id: user.id)
        label = task.labels.create(name: "sample", user_id: task.user.id)

        expect(label).to be_valid
        expect(task.label_relations.pluck(:label_id)).to include(label.id)
        expect(task.labels.pluck(:id)).to include(label.id)
      end

      it 'タスクとラベル作成を別々に作成した後に関連付けできる' do
        user = FactoryBot.create(:user)
        task = FactoryBot.create(:task, user_id: user.id)
        label = user.labels.create(name: "sample", user_id: user.id)

        LabelRelation.create(task_id: task.id, label_id: label.id)
        expect(task.labels.pluck(:id)).to include(label.id)
        expect(label.tasks.pluck(:id)).to include(task.id)
      end
    end

    context 'ユーザー、タスク、ラベルを削除した時の挙動' do
      before do
        @user = FactoryBot.create(:user)
        @task = FactoryBot.create(:task, user_id: @user.id)
        @label = @task.labels.create(name: "sample", user_id: @task.user.id)
      end

      it 'タスクが削除されてもラベルは削除されない' do
        expect(Task.all.count).to eq 1
        expect(Label.all.count).to eq 1
        @task.destroy

        expect(Task.all.count).to eq 0
        expect(Label.all.count).to eq 1
      end

      it 'タスクが削除されるとリレーションは削除される' do
        expect(LabelRelation.all.count).to eq 1
        @task.destroy
        expect(LabelRelation.all.count).to eq 0
      end

      it 'ラベルが削除されてもタスクは削除されない' do
        @label.destroy
        expect(Task.all.count).to eq 1
      end

      it 'ラベルが削除されるとリレーションは削除される' do
        expect(LabelRelation.all.count).to eq 1
        @task.destroy
        expect(LabelRelation.all.count).to eq 0
      end

      it 'ユーザーが削除されるとタスク、ラベルは削除される' do
        @user.destroy

        expect(User.all.count).to eq 0
        expect(Task.all.count).to eq 0
        expect(Label.all.count).to eq 0
      end

      it 'ユーザーが削除されるとリレーションは削除される' do
        expect(LabelRelation.all.count).to eq 1
        @user.destroy
        expect(LabelRelation.all.count).to eq 0
      end
    end
  end
end
