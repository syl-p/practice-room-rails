FactoryBot.define do
  factory :practice_activity do
    association :practice
    association :activity

    transient do
      tag_pool { [] }
    end

    after(:create) do |practice_activity, evaluator|
      practice_activity.activity.tags << evaluator.tag_pool.sample(3) if evaluator.tag_pool.any?
    end

    trait :with_goal do
      after(:create) do |practice_activity|
        goal = create(:goal, practice_activity: practice_activity, user: practice_activity.practice.user)
        create(:goal_progress, goal: goal)
      end
    end
  end
end
