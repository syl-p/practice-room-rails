FactoryBot.define do
  factory :practice do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    association :user

    transient do
      tag_pool { [] }
    end

    after(:create) do |practice, evaluator|
      practice.tags << evaluator.tag_pool.sample(5) if evaluator.tag_pool.any?
    end

    trait :with_activities do
      after(:create) do |practice, evaluator|
        create_list(:practice_activity, rand(1..5), :with_goal, practice: practice, tag_pool: evaluator.tag_pool)
      end
    end
  end
end
