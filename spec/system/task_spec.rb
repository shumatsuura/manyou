require 'rails_helper'

def visit_with_http_auth(path)
  username = ENV['BASIC_AUTH_NAME']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#
  {Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'タスク管理機能', type: :system, js: true do
  describe 'タスク一覧画面' do
    before do
      @task = FactoryBot.create(:task, name: 'task' ,due: DateTime.now, status: '着手中', priority: 2)
    end

    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示されること' do
        visit_with_http_auth tasks_path
        expect(page).to have_content 'task'
        expect(page).to have_content '着手中' #statusのテスト
        expect(page).to have_content 'high' #priorityのテスト
      end
    end

    context '複数のタスクを作成した場合' do
      it 'タスクが作成日時の降順に並んでいること' do
        new_task = FactoryBot.create(:task, name: 'new_task', status: '完了', priority: 1)
        visit tasks_path

        task_name_list = all('.task_name_row')
        expect(task_name_list[0]).to have_content 'new_task'
        expect(task_name_list[1]).to have_content 'task'

        task_status_list = all('.task_status_row')
        expect(task_status_list[0]).to have_content '完了'
        expect(task_status_list[1]).to have_content '着手中'

        task_priority_list = all('.task_priority_row')
        expect(task_priority_list[0]).to have_content 'medium'
        expect(task_priority_list[1]).to have_content 'high'


      end
    end

    context 'ソートを行った場合' do
      it 'タスクが終了期限の降順に並んでいること' do

        current_time1 = DateTime.now
        n = 0
        10.times do
          FactoryBot.create(:task, due: current_time1 + 10.year - n.year)
          n += 1
        end
        @tasks = Task.all

        visit tasks_path

        select '終了期限：降順', from:'index_sort'

        task_list = all('.task_due_row') # タスク一覧を配列として取得するため、View側でidを振っておく
        expect(task_list[0]).to have_content (current_time1 +10.year).strftime("%Y年%m月%d日 %H:%M")

      end
    end
  end

  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存されること' do
        # new_task_pathにvisitする（タスク登録ページに遷移する）
        # 1.ここにnew_task_pathにvisitする処理を書く
        visit new_task_path
        current_time = DateTime.now

        fill_in 'タスク名', with: 'passing manyou kadai'
        fill_in 'タスク詳細', with: 'step1~5 + option requirement'
        select current_time.strftime("%Y"), from: 'task_due_1i'
        select current_time.strftime("%-m月"), from: 'task_due_2i'
        select current_time.strftime("%-d"), from: 'task_due_3i'
        select current_time.strftime("%H"), from: 'task_due_4i'
        select current_time.strftime("%M"), from: 'task_due_5i'

        click_button '登録する'

        expect(page).to have_content 'タスクが登録されました。'
        expect(page).to have_content 'passing manyou kadai'
        expect(page).to have_content 'step1~5 + option requirement'
        expect(page).to have_content current_time.strftime("%Y年%m月%d日 %H:%M")
        expect(page).to have_current_path task_path(Task.last.id), ignore_query: true
      end
    end
  end

  describe 'タスク詳細画面' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移すること' do
         task = FactoryBot.create(:task, name:'pleaseclickhere2', description:'yes')
         visit tasks_path
         click_on 'pleaseclickhere2'
         expect(page).to have_current_path task_path(task.id)
       end
     end
  end
end
