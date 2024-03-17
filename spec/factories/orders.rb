FactoryBot.define do
  factory :order do
    guid { SecureRandom.uuid }
    merchant
    amount { rand(1..100) }
  end
end
