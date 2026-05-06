FactoryBot.define do
  factory :goal do
    unit { %w[bpm km reps].sample }
    target_value { rand(1..200) }
    association :practice_activity
    association :user

    trait :with_progresses do
      after(:create) do |goal|
        FactoryBot.create_list(:goal_progress, rand(1..5), goal: goal)
      end
    end
  end
end
