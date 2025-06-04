FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.words(number: 2).join(" ") }
  end
end
