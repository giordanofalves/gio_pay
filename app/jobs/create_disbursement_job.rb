class CreateDisbursementJob < ApplicationJob
  queue_as :high

  def perform(merchant_id,date, order_ids)
    merchant      = Merchant.find(merchant_id)
    disbursement  = merchant.disbursements.create(created_at: date)

    disbursement.process_orders(order_ids)
  end
end
