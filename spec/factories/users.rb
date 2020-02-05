FactoryBot.define do
  factory :user do
    name { "muridatta" }
    email { Faker::Internet.email }
    password { "password" }
    admin { false }
  end
end
