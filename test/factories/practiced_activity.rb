FactoryBot.define do
  factory :practiced_activity do
    user { association(:user) }
    activity { association(:activity) }
    duration { 30 }
  end
end
