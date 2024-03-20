# == Schema Information
#
# Table name: monthly_fees
#
#  id                 :bigint           not null, primary key
#  merchant_reference :string           not null
#  month              :date
#  amount             :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :monthly_fee do
    merchant { nil }
    month { "2024-03-19" }
    amount { "9.99" }
  end
end
