require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :model do

  it 'nameが空ならバリデーションが通らない' do
    task = Task.new(name: '', description: '失敗テスト')
    expect(task).not_to be_valid
  end

  it 'descriptionが空ならバリデーションが通らない' do
    task = Task.new(name: '失敗テスト', description: '')
    expect(task).not_to be_valid
  end

  it 'nameとdescriptionに内容が記載されていればバリデーションが通る' do
    task = Task.new(name: '成功テスト', description: '成功テスト')
    expect(task).to be_valid
  end
end
