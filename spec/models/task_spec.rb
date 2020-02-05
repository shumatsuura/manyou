require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :model do

  before do
    @task1 = FactoryBot.create(:task, name: 'testname_1', status: '着手中')
    @task2 = FactoryBot.create(:task, name: 'testname_2', status: '着手中')
    @task3 = FactoryBot.create(:task, name: 'testname_3', status: '完了')
    @task4 = FactoryBot.create(:task, name: 'testname_4', status: '未着手', user_id: @task3.user.id )
    FactoryBot.create_list(:task, 100)
  end

  it 'nameが空ならバリデーションが通らない' do
    task = FactoryBot.build(:task, name: '', description: '失敗テスト')
    expect(task).not_to be_valid
  end

  it 'descriptionが空ならバリデーションが通らない' do
    task = FactoryBot.build(:task, name: '失敗テスト', description: '')
    expect(task).not_to be_valid
  end

  it 'nameとdescriptionに内容が記載されていればバリデーションが通る' do
    task = FactoryBot.build(:task, name: '成功テスト', description: '成功テスト')
    expect(task).to be_valid
  end

  it 'statusが空ならバリデーションが通らない' do
    task = FactoryBot.build(:task, status: '')
    expect(task).not_to be_valid
  end

  it 'priorityが空ならバリデーションが通らない' do
    task = FactoryBot.build(:task, priority: '')
    expect(task).not_to be_valid
  end

  it 'priorityがenumで設定した値ならバリデーションが通る' do
    task = FactoryBot.build(:task, priority: 1)
    expect(task).to be_valid
  end

  it 'neme検索' do
    tasks = Task.search_by_name(@task1.user.id,'testname_1')
    expect(tasks.pluck(:name)).to include('testname_1')
    expect(tasks.pluck(:name)).not_to include('testname_2')
  end

  it 'status検索' do
    tasks = Task.search_by_status(@task3.user.id,'完了')
    expect(tasks.pluck(:status)).to include('完了')
    expect(tasks.pluck(:status)).not_to include('着手中')
    expect(tasks.pluck(:status)).not_to include('未着手')
  end

  it 'name & status検索' do
    tasks = Task.search_by_name_and_status(@task1.user.id,'testname_1','着手中')

    expect(tasks.pluck(:name)).to include('testname_1')
    expect(tasks.pluck(:name)).not_to include('testname_2')

    expect(tasks.pluck(:status)).to include('着手中')
    expect(tasks.pluck(:status)).not_to include('完了')
    expect(tasks.pluck(:status)).not_to include('未着手')
  end

end
