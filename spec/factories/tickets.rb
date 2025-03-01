FactoryBot.define do
  factory :ticket do
    event { nil }
    category { "MyString" }
    price { "9.99" }
    quantity { 1 }
  end
end
