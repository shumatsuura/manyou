FactoryBot.define do
  factory :user do
    name { "muridatta" }
    sequence(:email) { |n| "testuser_#{n}@sample.com" }
    password { "password" }
    admin { false }
  end
end
