require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    before do
      @user = FactoryBot.create(:user, admin: true)
      FactoryBot.create_list(:user, 100)
    end

    it 'nameが空ならバリデーションが通らない' do
      user = FactoryBot.build(:user, name: '')
      expect(user).not_to be_valid
    end

    it 'emailが空ならバリデーションが通らない' do
      user = FactoryBot.build(:user, email: '')
      expect(user).not_to be_valid
    end

    it 'passwordが空ならバリデーションが通らない' do
      user = FactoryBot.build(:user, password: '')
      expect(user).not_to be_valid
    end

    it '通常ユーザーの削除' do
      x = User.all
      expect{ User.last.destroy }.to change{ x.size }.from(101).to(100)
    end

    it 'adminの削除' do
      x = User.all.count
      User.first.destroy
      y = User.all.count
      expect(x - y).to eq 0
    end

    it 'adminの変更' do
      expect(User.where(admin: true).count).to eq 1
      user = User.find_by(admin: true)
      user.update(admin: false)
      expect(User.where(admin: true).count).to eq 1
    end
  end
end
