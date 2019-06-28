FactoryBot.define do
  factory :store do
    name {"name"}
    long_stay {1}
    consent {:consent_ari}
    wifi {:wifi_ari}
    wifi_description {"Wi2/Wi2_club"}
    comment {"コメントコメントコメントコメントコメントコメント"}
    association :user
    status {0}
  end
end
