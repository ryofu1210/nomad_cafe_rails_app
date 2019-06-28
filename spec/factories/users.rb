FactoryBot.define do
  factory :user do
    nickname {"testtest"}
    profile {"プロフィールプロフィールプロフィール"}
    email {"testtest@example.com"}
    password {"password"}
    password_confirmation {"password"}
    confirmed_at {Time.now}
  end
end
