# == Schema Information
#
# Table name: disbursements
#
#  id          :bigint           not null, primary key
#  reference   :string
#  merchant_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class DisbursementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
