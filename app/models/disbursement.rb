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
class Disbursement < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  has_many :orders, foreign_key: :disbursement_reference, primary_key: :reference

  after_create :generate_reference

  def process_orders(order_ids)
    orders        = Order.where(id: order_ids)
    orders_values = orders.pluck('SUM(to_pay)', 'SUM(fee)').map { |to_pay, fee| { to_pay: to_pay, fee: fee } }.first

    update(amount: orders_values[:to_pay], fee: orders_values[:fee])
    orders.update_all(disbursement_reference: reference, status: :processed)
  end

  private

  def generate_reference
    update(reference: SecureRandom.alphanumeric(10))
  end
end
