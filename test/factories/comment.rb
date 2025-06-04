FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    association :user
    commentable { association :activity } # Assuming activity is the polymorphic type
  end
end
