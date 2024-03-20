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
class MonthlyFee < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
end
