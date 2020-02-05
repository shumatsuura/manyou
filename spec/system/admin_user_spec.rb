require 'rails_helper'

# def visit_with_http_auth(path)
#   username = ENV['BASIC_AUTH_NAME']
#   password = ENV['BASIC_AUTH_PASSWORD']
#   visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#
#   {Capybara.current_session.server.port}#{path}"
# end

RSpec.describe 'ユーザー機能', type: :system, js: true do
  before do
    @user1 = User.create(name: 'user1' , email: 'user1@sample.com', password: "password", password_confirmation: "password", admin: true)
    @user2 = User.create(name: 'user2' , email: 'user2@sample.com', password: "password", password_confirmation: "password")
  end

  describe 'アドミンユーザーのアクセス権限' do
    before do
      visit new_session_path
      fill_in 'Email', with: 'user1@sample.com'
      fill_in 'Password', with: "password"
      click_on "Log in"
    end

    it 'アドミン管理一覧画面にアクセスできる' do
      visit admin_users_path
      expect(page).to have_current_path admin_users_path
    end

    it 'アドミン管理ユーザー作成画面にアクセスできる' do
      visit new_admin_user_path

      fill_in 'Name', with: 'user_generated_by_admin_user'
      fill_in 'Email', with: 'user_generated_by_admin_user@sample.com'
      fill_in 'Password', with: "password"
      fill_in 'Password confirmation', with: "password"

      click_button '登録する'

      expect(page).to have_content 'user_generated_by_admin_user'
      expect(page).to have_content 'user_generated_by_admin_user@sample.com'
    end

    it 'アドミン管理ユーザー詳細画面にアクセスできる' do
      visit admin_user_path(@user2.id)
      expect(page).to have_current_path admin_user_path(@user2.id)
    end

    it 'アドミン管理ユーザー編集画面にアクセスできる' do
      visit edit_admin_user_path(@user2.id)
      expect(page).to have_current_path edit_admin_user_path(@user2.id)
    end

    it '他のユーザーを削除できる' do
      visit edit_admin_user_path(@user2.id)
      click_on '削除する'

      expect(page).to have_content "削除しました。"
      expect(User.find_by(id: @user2.id)).to eq nil
    end

    it '他のユーザーを編集できる' do
      visit edit_admin_user_path(@user2.id)
      fill_in 'Name', with: 'user3'
      fill_in 'Email', with: 'user3@sample.com'

      check 'Admin'
      click_on '更新する'

      expect(page).to have_content "更新しました。"
      expect(User.find_by(id: @user2.id).name).to eq 'user3'
      expect(User.find_by(id: @user2.id).email).to eq 'user3@sample.com'
      expect(User.find_by(id: @user2.id).admin).to eq true
    end


  end
end
