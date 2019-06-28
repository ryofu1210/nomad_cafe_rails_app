FactoryBot.define do
  factory :user do
    nickname {"testtest"}
    profile {"プロフィールプロフィールプロフィール"}
    sequence(:email) {|n| "rspec_test#{n}@example.com"}
    password {"password"}
    password_confirmation {"password"}
    confirmed_at {Time.now}
  end
end
