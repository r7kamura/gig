FactoryGirl.define do
  factory :user do
    nickname { "nickname" }
    provider { "provider" }
    token { "token" }
    sequence(:uid) {|n| n.to_s }

    factory :admin do
      nickname { Settings.github.nickname }
    end
  end
end
