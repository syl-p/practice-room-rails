FactoryBot.define do
  factory :goal do
    unit { %w[bpm km reps].sample }
    target_value { 100 }
    association :practice_activity
    association :user

    trait :with_progresses do
      after(:create) do |goal|
        FactoryBot.create_list(:goal_progress, rand(1..10), goal: goal)
      end
    end
  end
end
