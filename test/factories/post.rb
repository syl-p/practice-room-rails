FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 5) }
    excerpt { Faker::Lorem.paragraph(sentence_count: 2) }
    content { "<div>#{Faker::Lorem.paragraphs(number: 3).join('</div><div>')}</div>" }
    meta_description { Faker::Lorem.sentence(word_count: 16) }
    slug { nil }
    status { :published }
    user

    trait :draft do
      status { :draft }
    end

    trait :with_cover do
      cover { Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/avatar.png"), "image/png") }
    end

    trait :with_comments do
      after(:create) do |post|
        FactoryBot.create_list(:comment, 3, commentable: post)
      end
    end
  end
end
