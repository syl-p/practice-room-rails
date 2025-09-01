FactoryBot.define do
  factory :follow do
    association :follower, factory: :user
    association :following, factory: :activity

    # exist case
    before(:create) do |follow|
      while follow.follower_id == follow.following_id
        follow.following = FactoryBot.create(:user)
      end
    end
  end
end
