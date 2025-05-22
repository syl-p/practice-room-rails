FactoryBot.define do
  factory :activity do
    title { "Sample Activity" }
    slug { "sample-activity" }
    content { "This is the content of the activity." }
    association :user, factory: :user
  end
end
