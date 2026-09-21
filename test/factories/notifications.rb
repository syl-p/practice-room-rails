FactoryBot.define do
  factory :notification do
    user
    association :notifiable, factory: :comment

    trait :comment do
      notification_type { :comment }
    end

    trait :mention do
      notification_type { :mention }
    end
  end
end
