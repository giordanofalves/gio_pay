FactoryBot.define do
  factory :merchant do
    guid                { SecureRandom.uuid }
    reference           { SecureRandom.uuid }
    email               { Faker::Internet.email }
    live_on             { Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now - 1.month) }
    minimum_monthly_fee { Faker::Number.decimal(l_digits: 2) }
    daily_disbursemen_frequency

    trait :daily_disbursemen_frequency do
      disbursement_frequency { 0 }
    end

    trait :weekly_disbursemen_frequency do
      disbursement_frequency { 1 }
    end
  end
end
