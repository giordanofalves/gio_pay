class MonthlyFee < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
end
