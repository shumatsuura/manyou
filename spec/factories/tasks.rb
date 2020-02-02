FactoryBot.define do
  factory :task do
    # 下記の内容は実際に作成するカラム名に合わせて変更してください
    sequence(:name) { |n| "testname_#{n}" }
    sequence(:description) { |n| "test_description#{n}" }
    status {["未着手","着手中","完了"].sample}
    priority {rand(0..2)}
  end
end
