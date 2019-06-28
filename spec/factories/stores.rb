FactoryBot.define do
  factory :store do
    name {"name"}
    long_stay {1}
    consent {true}
    wifi {true}
    wifi_description {"Wi2/Wi2_club"}
    comment {"コメントコメントコメントコメントコメントコメント"}
    association :user
    status {0}
  end
end
