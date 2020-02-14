FactoryBot.define do
  factory :group do
    association :user
    sequence(:name) { |n| "group_#{n}" }
    sequence(:description) { |n| "group_description_#{n}" }
  end
end
