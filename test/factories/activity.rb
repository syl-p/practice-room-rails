FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph }
    slug { nil }
    user { association :user }
    default_unit { %w[bpm km reps].sample }
    default_target_value { Faker::Number.between(from: 1, to: 100) }

    transient do
      tag_pool { [] }
      user_pool { [] }
    end

    after(:create) do |activity, evaluator|
      activity.tags << evaluator.tag_pool.sample(5) if evaluator.tag_pool.any?
      activity.user = evaluator.user_pool.shuffle.first if evaluator.user_pool.any?

      activity.save
    end

    trait :draft do
      status { :draft }
    end

    trait :public do
      status { :published }
    end

    trait :with_comments do
      after(:create) do |activity|
        FactoryBot.create_list(:comment, 5, commentable: activity)
      end
    end

    trait :with_media do
      after(:create) do |activity|
        activity.media = create(:medium)
      end
    end
  end
end
