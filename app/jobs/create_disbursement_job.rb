class CreateDisbursementJob < ApplicationJob
  queue_as :high

  def perform(merchant_id)
    merchant = Merchant.find(merchant_id)
    merchant.perform_disbursements
  end
end
