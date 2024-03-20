# == Schema Information
#
# Table name: orders
#
#  id                     :bigint           not null, primary key
#  guid                   :string           not null
#  status                 :integer          default("pending"), not null
#  amount                 :decimal(10, 2)
#  fee                    :decimal(10, 2)
#  to_pay                 :decimal(10, 2)
#  merchant_reference     :string           not null
#  disbursement_reference :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
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
