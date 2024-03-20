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
require "test_helper"

class MonthlyFeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
