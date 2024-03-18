FactoryBot.define do
  factory :disbursement do
    merchant
    amount    { rand(1..100) }
    reference { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
    fee       { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
