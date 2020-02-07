require 'rails_helper'

RSpec.describe 'ラベル機能', type: :system, js: true do
  before do
    @user = User.create(name:"matsu", email: "sample@sample.com", password:"password", password_confirmation: "password")
    @task = FactoryBot.create(:task, name: 'task' ,due: DateTime.now, status: '着手中', priority: 2, user_id: @user.id)
    visit root_path
    click_on 'ログイン'
    fill_in 'Email', with: 'sample@sample.com'
    fill_in 'Password', with: "password"
    click_on 'Log in'
  end

  describe 'ラベル機能' do
    context '新規ユーザーが新規にタスクを登録する場合' do
      it '既存ラベルは存在しない' do
        visit new_task_path
        label_list = all('.label-default')
        expect(label_list.count).to eq 0
      end
    end

    context '新規にラベルを作成する場合' do
      it 'ユーザー詳細ページから新規ラベル作成ページに遷移できる' do
        visit user_path(@user.id)
        click_on '新規ラベル追加'
        expect(page).to have_current_path(new_label_path)
      end

      it 'ラベルを登録でき、表示される' do
        visit new_label_path
        fill_in 'Name', with: "ラベル１"
        click_on '登録する'
        expect(page).to have_content 'ラベルが登録されました。'
        expect(page).to have_current_path user_path(@user.id)
        label_list = all('.label-default')
        expect(label_list[0]).to have_content 'ラベル１'
      end
    end

    context 'ラベルとタスクを関連づけする場合' do
      before do
        n =1
        5.times do
          Label.create(id: n, name: "label_#{n}",user_id: @user.id)
          n += 1
        end
        @n = n
      end

      it '作成済みのラベルが表示される' do
        visit new_task_path
        label_list = all('.label-default')
        expect(label_list.count).to eq 5
        expect(label_list[0]).to have_content 'label_1'
      end

      it 'タスク作成時に作成済みのラベルと関連づけできる' do
        visit new_task_path
        current_time = DateTime.now

        fill_in 'タスク名', with: 'passing manyou kadai'
        fill_in 'タスク詳細', with: 'step1~5 + option requirement'
        select current_time.strftime("%Y"), from: 'task_due_1i'
        select current_time.strftime("%-m月"), from: 'task_due_2i'
        select current_time.strftime("%-d"), from: 'task_due_3i'
        select current_time.strftime("%H"), from: 'task_due_4i'
        select current_time.strftime("%M"), from: 'task_due_5i'

        check "task_label_ids_1"
        click_button '登録する'

        expect(page).to have_content 'タスクが登録されました。'
        expect(page).to have_content 'label_1'
      end

      it 'タスク編集時に作成済みの複数のラベルと関連づけできる' do
        visit edit_task_path(@task.id)
        expect(page).to  have_current_path edit_task_path(@task.id)
        check "task_label_ids_1"
        check "task_label_ids_2"

        click_button '更新する'
        label_list = all('.label-default')
        expect(label_list[0]).to have_content 'label_1'
        expect(label_list[1]).to have_content 'label_2'
      end

      it '他人が作成したラベルは表示されない' do
        other_user = User.create(name:"matsu2", email: "sample2@sample.com", password:"password", password_confirmation: "password")
        other_user_label = other_user.labels.create(id: @n,name: "other_user_label")

        visit edit_task_path(@task.id)
        expect(page).to have_current_path edit_task_path(@task.id)

        label_list = all('.label-default')
        expect(page).not_to have_content "#{other_user_label.name}"
      end
    end

    context 'ラベルを編集、削除する場合' do
      before do
        @user.labels.create(name: "test_label")
      end

      it '編集ページで名前を変更できる' do
        visit user_path(@user.id)
        click_on 'test_label'

        fill_in 'Name', with: "modified_test_label"
        click_on '更新する'

        expect(page).to have_content "modified_test_label"
        expect(page).to have_current_path user_path(@user.id)
      end

      it 'ラベルを削除できる' do
        visit user_path(@user.id)
        click_on 'test_label'
        click_on '削除する'

        expect(page).to_not have_content "testlabel"
        expect(page).to have_current_path user_path(@user.id)
      end
    end
  end

  describe 'ラベル機能のアクセス権限' do
    before do
      @other_user = User.create(name:"matsu2", email: "sample2@sample.com", password:"password", password_confirmation: "password")
      @other_user_label = @other_user.labels.create(name: "other_user_label")
    end

    it '他人のラベルの編集ページにアクセスできない' do
      visit edit_label_path(@other_user_label.id)
      expect(page).to have_current_path tasks_path
    end
  end

end
