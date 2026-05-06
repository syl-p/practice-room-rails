FactoryBot.define do
  factory :goal_progress do
    value { rand(1..200) }
    association :goal, factory: :goal
  end
end
