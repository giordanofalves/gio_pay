FactoryBot.define do
  factory :merchant do
    guid { SecureRandom.uuid }
    merchant
    amount { rand(1..100) }
  end
end
