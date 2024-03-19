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

  before_create :check_previous_monthly_fee
  before_create :generate_reference

  def process_orders(order_ids)
    orders        = Order.where(id: order_ids)
    orders_values = orders.pluck('SUM(to_pay)', 'SUM(fee)').map { |to_pay, fee| { to_pay: to_pay, fee: fee } }.first

    update(amount: orders_values[:to_pay], fee: orders_values[:fee])
    orders.update_all(disbursement_reference: reference, status: :processed)
  end

  private

  def check_previous_monthly_fee
    previous_records_on_month = merchant.disbursements.where('created_at >= ?', self.created_at.beginning_of_month).present?

    return if previous_records_on_month
    last_month_disbursements = merchant.last_month_disbursements(created_at)

    return if last_month_disbursements.empty?
    total_disbursed_last_month = last_month_disbursements.sum(:fee)

    return if total_disbursed_last_month >= merchant.minimum_monthly_fee
    merchant.monthly_fees.create(month: created_at.beginning_of_month, amount: merchant.minimum_monthly_fee - total_disbursed_last_month )
  end

  def generate_reference
    self.reference = SecureRandom.alphanumeric(10)
  end
end
