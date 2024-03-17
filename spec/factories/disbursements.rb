FactoryBot.define do
  factory :disbursement do
    guid { SecureRandom.uuid }
    merchant
    amount { rand(1..100) }
  end
end
