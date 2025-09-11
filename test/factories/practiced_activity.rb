FactoryBot.define do
  factory :practiced_activity do
    user { association(:user) }
    activity { association(:activity) }
    association :practice
    duration { 30 }
  end
end
