require 'rails_helper'

# def visit_with_http_auth(path)
#   username = ENV['BASIC_AUTH_NAME']
#   password = ENV['BASIC_AUTH_PASSWORD']
#   visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#
#   {Capybara.current_session.server.port}#{path}"
# end

RSpec.describe 'ユーザー機能', type: :system, js: true do
  before do
    @user1 = User.create(name: 'user1' , email: 'user1@sample.com', password: "password", password_confirmation: "password")
    @user2 = User.create(name: 'user2' , email: 'user2@sample.com', password: "password", password_confirmation: "password")
  end

  describe 'ユーザー登録関連' do
    context '新規ユーザーのサインアップ' do
      it 'Sign Upページに遷移すること' do
        visit root_path

        click_on 'Sign Up'
        expect(page).to have_current_path new_user_path
      end

      it '登録でき、詳細ページにリダイレクトされること' do
        visit new_user_path

        fill_in 'Name', with: 'Shunsuke'
        fill_in 'Email', with: 'shunsukE@sample.com'
        fill_in 'Password', with: "password"
        fill_in 'Password confirmation', with: "password"
        click_button '登録する'

        expect(page).to have_content 'Shunsuke'
        expect(page).to have_content 'shunsuke@sample.com'
      end

      it 'ログインして詳細ページにリダイレクトされること' do
        visit new_session_path
        fill_in 'Email', with: 'user1@sample.com'
        fill_in 'Password', with: "password"
        click_on "Log in"

        expect(page).to have_current_path user_path(@user1.id)
      end
    end
  end

  describe '未ログインユーザーのアクセス権限' do
    it '未ログインではタスクページにアクセスできないこと' do
      visit tasks_path
      expect(page).to have_current_path new_session_path
      expect(page).to have_content 'ログインしてください。'
    end

    it '未ログインではユーザー詳細ページにアクセスできないこと' do
      visit user_path(@user1.id)
      expect(page).to have_current_path new_session_path
      expect(page).to have_content 'ログインしてください。'
    end
  end

  describe 'ログインユーザーの機能' do
    before do
      visit new_session_path
      fill_in 'Email', with: 'user1@sample.com'
      fill_in 'Password', with: "password"
      click_on "Log in"
    end

    context '他ユーザーページへのアクセス制限、ログアウト機能' do
      it 'ログアウトできる' do
        visit tasks_path
        click_on "ログアウト"
        expect(page).to have_content "ログアウトしました。"
        expect(page).to have_current_path new_session_path
      end

      it '他ユーザーのページにアクセスできない' do
        visit user_path(@user2.id)
        expect(page).to have_current_path tasks_path
        expect(page).to have_content "権限がありません。"
      end

      it '他ユーザーのページにアクセスできない' do
        visit user_path(@user2.id)
        expect(page).to have_current_path tasks_path
        expect(page).to have_content "権限がありません。"
      end

      it 'ログイン後ユーザー登録ページにアクセスできない' do
        visit new_user_path
        expect(page).to have_current_path tasks_path
        expect(page).to have_content "既にログイン済みです。"
      end
    end

    context 'アドミン管理画面へのアクセス権限' do
      it 'アドミン管理一覧画面にアクセスできない' do
        visit admin_users_path
        expect(page).to have_current_path tasks_path
        expect(page).to have_content "権限がありません。"
      end

      it 'アドミン管理ユーザー詳細画面にアクセスできない' do
        visit admin_user_path(@user2.id)
        expect(page).to have_current_path tasks_path
        expect(page).to have_content "権限がありません。"
      end

      it 'アドミン管理ユーザー編集画面にアクセスできない' do
        visit edit_admin_user_path(@user2.id)
        expect(page).to have_current_path tasks_path
        expect(page).to have_content "権限がありません。"
      end
    end
  end
end
