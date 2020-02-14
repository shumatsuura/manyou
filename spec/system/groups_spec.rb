require 'rails_helper'

RSpec.describe 'グループ機能', type: :system, js: true do
  before do
    @user = User.create(id: 1, name:"matsu", email: "sample@sample.com", password:"password", password_confirmation: "password")
    @user2 = User.create(id: 2, name:"matsu2", email: "sample2@sample.com", password:"password", password_confirmation: "password")
    @task = FactoryBot.create(:task, name: 'task' ,due: DateTime.now, status: '着手中', priority: 2, user_id: 1)
    visit root_path
    click_on 'ログイン'
    fill_in 'Email', with: 'sample@sample.com'
    fill_in 'Password', with: "password"
    click_on 'Log in'
  end

  describe 'グループのCRUD機能' do
    context '一般のルーティング' do
      it 'Groupインデックスにアクセスできる' do
        click_on 'Group'
        expect(page).to have_current_path(groups_path)
      end
    end
  end

  describe 'グループ管理者の機能' do
    context 'CRUD機能' do
      before do
        @group = @user.groups.create(name: "サンプルグループ（it内）", description: "サンプルグループ（it内）")
        @group_task = @user.tasks.create(name:'グループタスクサンプル',description:'グループタスクサンプルの詳細',group_id: @group.id)
      end

      it 'グループを作成でき、作成したグループが表示される' do
        visit new_group_path
        fill_in 'グループ名', with: 'サンプルグループ１'
        fill_in 'グループ詳細', with: 'サンプルグループ１の詳細'
        click_button '登録する'

        expect(page).to have_content('サンプルグループ１')
        expect(page).to have_content('サンプルグループ１の詳細')
      end

      it 'グループを編集できる' do
        visit groups_path
        click_on '編集する'
        fill_in 'グループ名', with: '編集テスト'
        click_button '更新する'
        expect(page).to have_content('編集テスト')
      end

      it 'グループを削除できる' do
        visit groups_path
        click_on '削除する'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content('グループを削除しました。')
        expect(page).not_to have_content('サンプルグループ（it内）')
      end

      it 'グループの詳細ページにアクセスできる' do
        visit group_path(@group.id)
        expect(page).to have_current_path group_path(@group.id)
        expect(page).to have_content("#{@user.name}")
      end
    end

    context 'グループタスク関連' do
      before do
        @group = @user.groups.create(name: "サンプルグループ（it内）", description: "サンプルグループ（it内）")
        @group_task = @user.tasks.create(name:'グループタスクサンプル',description:'グループタスクサンプルの詳細',group_id: @group.id)
      end

      it 'グループタスクの作成ページにアクセスでき、作成できる' do
        current_time = DateTime.now
        visit new_group_group_task_path(@group.id)
        fill_in 'タスク名', with: 'グループタスク１'
        fill_in 'タスク詳細', with: 'グループタスク１の詳細'
        select current_time.strftime("%Y"), from: 'task_due_1i'
        select current_time.strftime("%-m月"), from: 'task_due_2i'
        select current_time.strftime("%-d"), from: 'task_due_3i'
        select current_time.strftime("%H"), from: 'task_due_4i'
        select current_time.strftime("%M"), from: 'task_due_5i'

        click_button '登録する'
        expect(page).to have_content('グループタスクを作成しました。')
        expect(page).to have_content('グループタスク１')
        expect(page).to have_content('グループタスク１の詳細')
      end

      it 'グループのタスクを参照できる' do
        visit group_group_task_path(@group.id, @group_task.id)
        expect(page).to have_content("#{@group_task.name}")
        expect(page).to have_content("#{@group_task.description}")
      end

      it '自分が作成したグループタスクを編集できる' do
        visit edit_group_group_task_path(@group.id, @group_task.id)
        fill_in 'タスク名', with: 'グループタスク１'
        fill_in 'タスク詳細', with: 'グループタスク１の詳細(編集)'
        click_button '更新する'

        expect(page).to have_content("グループタスク１の詳細(編集)")
      end

      it '他のメンバーが作成したグループのタスクを編集できない' do
        @user2.group_relations.create(group_id: @group.id)
        @group_task2 = @user2.tasks.create(name:'グループタスクサンプル', description:'グループタスクサンプルの詳細', group_id: @group.id)

        visit edit_group_group_task_path(@group.id, @group_task2.id)
        expect(page).to have_current_path(group_path(@group.id))
      end
    end
  end

  describe 'グループ未参加者の機能' do
    context 'グループページへのアクセス権限' do
      before do
        @group_2 = @user2.groups.create(name: "サンプルグループ２", description: "サンプルグループ２の詳細")
        @group_2_task = @user2.tasks.create(name:'グループタスクサンプル',description:'グループタスクサンプルの詳細',group_id: @group_2.id)
      end

      it 'グループに参加できる' do
        visit groups_path
        click_on 'グループに参加する'

        expect(page).not_to have_content('グループに参加する')
        visit group_path(@group_2.id)
        expect(page).to have_current_path(group_path(@group_2.id))
        expect(page).to have_content('サンプルグループ２')
      end

      it 'グループの詳細ページにアクセスできない' do
        visit group_path(@group_2.id)
        expect(page).to have_current_path(groups_path)
      end

      it 'グループの編集ページにアクセスできない' do
        visit edit_group_path(@group_2.id)
        expect(page).to have_current_path(groups_path)
      end

      it 'グループタスクの作成ページにアクセスできない' do
        visit new_group_group_task_path(@group_2.id)
        expect(page).to have_current_path(groups_path)
      end

      it 'グループのタスクを参照できない' do
        visit group_group_task_path(@group_2.id,@group_2_task.id)
        expect(page).to have_current_path(groups_path)
      end

      it 'グループのタスクを編集できない' do
        visit edit_group_group_task_path(@group_2.id,@group_2_task.id)
        expect(page).to have_current_path(groups_path)
      end

      it 'グループを編集できない' do
        visit edit_group_path(@group_2.id)
        expect(page).to have_current_path(groups_path)
      end
    end
  end

  describe 'グループメンバーの機能' do
    context 'グループメンバーのアクセス権限' do
      before do
        @group_2 = @user2.groups.create(name: "サンプルグループ２", description: "サンプルグループ２の詳細")
        @group_2_task = @user2.tasks.create(name:'グループタスクサンプル',description:'グループタスクサンプルの詳細',group_id: @group_2.id)
        @user.group_relations.create(group_id: @group_2.id)
      end

      it 'グループから抜けることができる' do
        visit groups_path
        click_on 'グループから抜ける'

        expect(page).not_to have_content('グループから抜ける')
        visit group_path(@group_2.id)
        expect(page).to have_current_path(groups_path)
      end

      it 'グループの詳細ページにアクセスできる' do
        visit group_path(@group_2.id)
        expect(page).to have_current_path(group_path(@group_2.id))
      end

      it 'グループの編集ページにアクセスできない' do
        visit edit_group_path(@group_2.id)
        expect(page).to have_current_path(groups_path)
      end

      it 'グループタスクの作成ページにアクセスでき、作成できる' do
        current_time = DateTime.now
        visit new_group_group_task_path(@group_2.id)
        fill_in 'タスク名', with: 'グループタスク１'
        fill_in 'タスク詳細', with: 'グループタスク１の詳細'
        select current_time.strftime("%Y"), from: 'task_due_1i'
        select current_time.strftime("%-m月"), from: 'task_due_2i'
        select current_time.strftime("%-d"), from: 'task_due_3i'
        select current_time.strftime("%H"), from: 'task_due_4i'
        select current_time.strftime("%M"), from: 'task_due_5i'

        click_button '登録する'
        expect(page).to have_content('グループタスクを作成しました。')
        expect(page).to have_content('グループタスク１')
        expect(page).to have_content('グループタスク１の詳細')
      end

      it 'グループのタスクを参照できる' do
        visit group_group_task_path(@group_2.id,@group_2_task.id)
        expect(page).to have_current_path(group_group_task_path(@group_2.id,@group_2_task.id))
      end

      it '自分が作成したグループのタスクを編集できる' do
        task = @user.tasks.create(name:'グループタスクサンプル',description:'グループタスクサンプルの詳細',group_id: @group_2.id)
        visit edit_group_group_task_path(@group_2.id, task.id)
        fill_in 'タスク名', with: 'グループタスク１'
        fill_in 'タスク詳細', with: 'グループタスク１の詳細(編集)'
        click_button '更新する'

        expect(page).to have_content("グループタスク１の詳細(編集)")
      end

      it '他のメンバーが作成したグループのタスクを編集できない' do
        visit edit_group_group_task_path(@group_2.id, @group_2_task.id)
        expect(page).to have_current_path(group_path(@group_2))
      end

      it 'グループを編集できない' do
        visit edit_group_path(@group_2.id)
        expect(page).to have_current_path(groups_path)
      end
    end
  end
end
