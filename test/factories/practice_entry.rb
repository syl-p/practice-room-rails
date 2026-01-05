FactoryBot.define do
  factory :practice_entry do
    user { association(:user) }
    activity { association(:activity) }
    association :practice
    duration { 30 }
  end
end
