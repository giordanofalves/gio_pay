class Disbursement < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  has_many :payments
  has_many :orders, through: :payments

  after_create :generate_reference
  # todo allow to create disbursements only before 08:00 UTC

  def process_payments(orders)
    # maybe move this to a state machine and trigger when order is processed
    orders.each do |order|
      fee    = order.calculate_fee
      amount = (order.amount - fee)

      payments.create(amount: amount, fee: fee, order_id: order.id)
    end

    update(amount: payments.sum(:amount), fee: payments.sum(:fee))
  end

  private

  def generate_reference
    update(reference: SecureRandom.alphanumeric(10))
  end
end
