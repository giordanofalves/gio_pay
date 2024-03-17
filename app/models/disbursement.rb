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
  has_many :orders, foreign_key: :merchant_reference, primary_key: :reference

  after_create :generate_reference
  # todo allow to create disbursements only before 08:00 UTC

  def process_orders(orders_data)
    orders_data.each(&:generate_fee)
    update(amount: orders_data.sum(&:to_pay), fee: orders_data.sum(&:to_pay))

    orders_data.each{ |o| o.update(disbursement_reference: reference, status: :processed) }
  end

  private

  def generate_reference
    update(reference: SecureRandom.alphanumeric(10))
  end
end
