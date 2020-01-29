require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe 'タスク一覧画面' do
    before do
      @task = FactoryBot.create(:task, name: 'task')
    end

    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示されること' do
        visit tasks_path
        expect(page).to have_content 'task'
      end
    end

    context '複数のタスクを作成した場合' do
      it 'タスクが作成日時の降順に並んでいること' do
        new_task = FactoryBot.create(:task, name: 'new_task')
        visit tasks_path
        task_list = all('.task_row') # タスク一覧を配列として取得するため、View側でidを振っておく
        expect(task_list[0]).to have_content 'new_task'
        expect(task_list[1]).to have_content 'task'
      end
    end
  end

  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存されること' do
        # new_task_pathにvisitする（タスク登録ページに遷移する）
        # 1.ここにnew_task_pathにvisitする処理を書く
        visit new_task_path

        # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
        # タスクのタイトルと内容をそれぞれfill_in（入力）する
        # 2.ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in 'タスク名', with: 'passing manyou kadai'

        # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in 'タスク詳細', with: 'step1~5 + option requirement'

        # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
        # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
        click_button '登録する'

        # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
        # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
        # 5.タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
        expect(page).to have_content 'タスクが登録されました。'
        expect(page).to have_content 'passing manyou kadai'
        expect(page).to have_content 'step1~5 + option requirement'
        expect(page).to have_current_path task_path(Task.last.id), ignore_query: true
      end
    end
  end

  describe 'タスク詳細画面' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移すること' do
         task = FactoryBot.create(:task, name:'task', description:'pleaseclickhere2')
         visit tasks_path
         click_on 'pleaseclickhere2'
         expect(page).to have_current_path task_path(task.id)
       end
     end
  end
end
