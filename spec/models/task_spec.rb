require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :model do

  before do
    FactoryBot.create(:task, name: 'testname_1', status: '着手中')
    FactoryBot.create(:task, name: 'testname_2', status: '着手中')
    FactoryBot.create_list(:task, 100)
  end

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

  it 'statusが空ならバリデーションが通らない' do
    task = Task.new(name: '失敗テスト', description: '失敗テスト', status: '')
    expect(task).not_to be_valid
  end

  it 'priorityが空ならバリデーションが通らない' do
    task = Task.new(name: '失敗テスト', description: '失敗テスト', priority: '')
    expect(task).not_to be_valid
  end

  it 'priorityがenumで設定した値ならバリデーションが通る' do
    task = Task.new(name: '失敗テスト', description: '失敗テスト', priority: 1)
    expect(task).to be_valid
  end

  it 'neme検索' do
    tasks = Task.search_by_name('testname_1')
    expect(tasks.pluck(:name)).to include('testname_1')
    expect(tasks.pluck(:name)).not_to include('testname_2')
  end

  it 'status検索' do
    tasks = Task.search_by_status('完了')
    expect(tasks.pluck(:status)).to include('完了')
    expect(tasks.pluck(:status)).not_to include('着手中')
    expect(tasks.pluck(:status)).not_to include('未着手')
  end

  it 'name & status検索' do
    tasks = Task.search_by_name_and_status('testname_1','着手中')

    expect(tasks.pluck(:name)).to include('testname_1')
    expect(tasks.pluck(:name)).not_to include('testname_2')

    expect(tasks.pluck(:status)).to include('着手中')
    expect(tasks.pluck(:status)).not_to include('完了')
    expect(tasks.pluck(:status)).not_to include('未着手')
  end

end
