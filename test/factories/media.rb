FactoryBot.define do
  factory :medium do
    association :user
    file { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/avatar.png"), "image/png") }
  end
end
