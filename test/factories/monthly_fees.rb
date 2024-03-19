FactoryBot.define do
  factory :monthly_fee do
    merchant { nil }
    month { "2024-03-19" }
    amount { "9.99" }
  end
end
