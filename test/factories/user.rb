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
        practices = FactoryBot.create_list(:practice, 3, user: user, tag_pool: evaluator.tag_pool)
        activities = FactoryBot.create_list(:activity, 5, user: user, tag_pool: evaluator.tag_pool)

        practices.each do |practice|
          activities.sample(rand(1..3)).each do |activity|
            FactoryBot.create(:practice_activity, practice: practice, activity: activity)
            FactoryBot.create(:goal, practice_activity: PracticeActivity.last, user: user)
          end
        end
      end
    end
  end
end
