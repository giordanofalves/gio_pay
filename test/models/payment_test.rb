# == Schema Information
#
# Table name: payments
#
#  id              :bigint           not null, primary key
#  order_id        :bigint           not null
#  disbursement_id :bigint           not null
#  amount          :decimal(10, 2)
#  fee             :decimal(10, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
