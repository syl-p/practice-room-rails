FactoryBot.define do
  factory :practice_activity do
    association :practice
    association :activity

    trait :with_goal do
      after(:create) do |practice_activity|
        goal = create(:goal, practice_activity: practice_activity, user: practice_activity.practice.user)
        create(:goal_progress, goal: goal)
      end
    end
  end
end
