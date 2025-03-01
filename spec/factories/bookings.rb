FactoryBot.define do
  factory :booking do
    customer { nil }
    ticket { nil }
    quantity { 1 }
    total_amount { "9.99" }
    status { "MyString" }
  end
end
