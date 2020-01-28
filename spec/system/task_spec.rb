require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  context 'タスクを作成した場合' do
    # テストコードを it '~' do end ブロックの中に記載する
    it '作成済みのタスクが表示されること' do
      # テストで使用するためのタスクを作成
      task = FactoryBot.create(:task, name:'task')

      # タスク一覧ページに遷移
      visit tasks_path

      # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
      # have_contentされているか。（含まれているか。）ということをexpectする（確認・期待する）
      expect(page).to have_content 'task'

      # expectの結果が true ならテスト成功、false なら失敗として結果が出力される
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
        fill_in 'Name', with: 'passing manyou kadai'

        # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in 'Description', with: 'step1~5 + option requirement'

        # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
        # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
        click_button 'Create Task'

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
