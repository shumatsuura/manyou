FactoryBot.define do
  factory :task do
    association :user

    sequence(:name) { |n| "testname_#{n}" }
    sequence(:description) { |n| "test_description#{n}" }
    due { DateTime.now + 1.month }
    status {["未着手","着手中","完了"].sample}
    priority {rand(0..2)}

  end
end
