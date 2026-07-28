FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "#{Faker::Internet.username}_#{n}" }
    sequence(:email_address) { |n| "user#{n}@example.com" }
    bio { Faker::Lorem.paragraph }
    password { "password" }

    # create(:user, :with_practices, tag_pool: tags)
    trait :with_practices do
      transient do
        tag_pool { [] }
      end

      after(:create) do |user, evaluator|
        FactoryBot.create_list(:practice, 3, :with_activities, user: user, tag_pool: evaluator.tag_pool)
      end
    end
  end
end
