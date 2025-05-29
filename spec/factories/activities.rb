FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph }
    slug { nil }
    user { association :user }

    transient do
      tag_pool { [] }
    end

    after(:create) do |activity, evaluator|
      activity.tags << evaluator.tag_pool.sample(5) if evaluator.tag_pool.any?
      activity.save
    end

    trait :draft do
      status { :draft }
    end

    trait :public do
      status { :published }
    end
  end
end
