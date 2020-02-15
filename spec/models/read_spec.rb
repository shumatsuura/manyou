require 'rails_helper'

RSpec.describe Read, type: :model do
  before do
    @task1 = FactoryBot.create(:task, name: 'testname_1', status: '着手中')
    @user = FactoryBot.create(:user)

  end
  it 'user_idが空ならバリデーションが通らない' do
    read = Read.new(user_id: '',task_id: @task1.id)
    expect(read).not_to be_valid
  end

  it 'task_idが空ならバリデーションが通らない' do
    read = Read.new(user_id: @task1.user.id, task_id: '')
    expect(read).not_to be_valid
  end

  it 'user_id,task_idがあればバリデーションが通る' do
    read = Read.new(user_id: @user.id, task_id: @task1.id)
    expect(read).to be_valid
  end
end
