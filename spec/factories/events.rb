FactoryBot.define do
  factory :event do
    title { "MyString" }
    description { "MyText" }
    venue { "MyString" }
    start_date { "2025-03-01 06:10:13" }
    end_date { "2025-03-01 06:10:13" }
    event_organizer { nil }
  end
end
