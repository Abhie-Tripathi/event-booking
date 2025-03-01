FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-03-01 06:12:30" }
  end
end
