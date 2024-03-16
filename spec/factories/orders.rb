FactoryBot.define do
  factory :order do
    merchant
    guid                   { SecureRandom.uuid }
    amount                 { rand(1..100) }
    status                 { :pending }
    fee                    { Faker::Number.decimal(l_digits: 2) }
    to_pay                 { Faker::Number.decimal(l_digits: 2) }

    trait :with_disbursement do
      disbursement
    end
  end
end
