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
class Payment < ApplicationRecord
  # belongs_to :order
  # belongs_to :disbursement
end
