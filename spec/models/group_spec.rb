require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'バリデーション' do
    it '詳細が空だとバリデーションが通らない' do
      group = FactoryBot.build(:group, name: '')
      expect(group).not_to be_valid
    end

    it '名前が空だとバリデーションが通らない' do
      group = FactoryBot.build(:group, user_id: '')
      expect(group).not_to be_valid
    end

    it 'ユーザーと名前があればバリデーションが通る' do
      group = FactoryBot.build(:label)
      expect(group).to be_valid
    end
  end

  describe 'アソシエーションの操作' do
    context 'アソシエーション作成' do
      it 'ユーザとのアソシエーションでグループを作成できる' do
        user = FactoryBot.create(:user)
        group = user.groups.build(name:"sample", description: "sample")
        expect(group).to be_valid
      end

      it '他のユーザーが参加した場合のアソシエーション' do
        user = FactoryBot.create(:user)
        group = FactoryBot.create(:group, user_id: user.id)
        user2 = FactoryBot.create(:user)

        user2.group_relations.create(group_id: group.id)
        expect(user2.joined_groups.pluck(:id)).to include(group.id)
        expect(group.members.pluck(:id)).to include(user2.id)
      end
    end

    context 'ユーザー、グループを削除した時の挙動' do
      before do
        @user = FactoryBot.create(:user)
        @user2 = FactoryBot.create(:user)
        @group = FactoryBot.create(:group, user_id: @user.id)

        @user2.group_relations.create(group_id: @group.id)
        @task = @user2.tasks.create(name: "sample",description: "sample", group_id: @group.id)
      end

      it 'グループが削除されてもユーザーは削除されない' do
        expect(User.all.count).to eq 2
        expect(Group.all.count).to eq 1
        @group.destroy

        expect(User.all.count).to eq 2
        expect(Group.all.count).to eq 0
      end

      it 'グループが削除されるとリレーションは削除される' do
        expect(GroupRelation.all.count).to eq 1
        @group.destroy
        expect(GroupRelation.all.count).to eq 0
      end

      it 'グループが削除されてもグループタスクは削除されない' do
        expect(Task.all.count).to eq 1
        @group.destroy
        expect(Task.all.count).to eq 1
      end

      it 'ユーザーが削除されるとリレーション、グループタスクは削除される' do
        expect(GroupRelation.all.count).to eq 1
        expect(Task.all.count).to eq 1
        @user2.destroy
        expect(GroupRelation.all.count).to eq 0
        expect(Task.all.count).to eq 0
      end
    end
  end
end
