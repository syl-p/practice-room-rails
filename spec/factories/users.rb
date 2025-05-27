FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.email }
    password { "password" }

    trait :with_activities do
      transient do
        tag_pool { [] }
      end

      after(:create) do |user, evaluator|
        FactoryBot.create_list(:activity, 10, tag_pool: evaluator.tag_pool, user: user)
      end
    end
  end
end
