# == Schema Information
#
# Table name: disbursements
#
#  id                 :bigint           not null, primary key
#  reference          :string
#  merchant_reference :string           not null
#  amount             :decimal(10, 2)
#  fee                :decimal(10, 2)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :disbursement do
    merchant
    amount    { rand(1..100) }
    reference { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
    fee       { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
