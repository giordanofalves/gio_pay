# == Schema Information
#
# Table name: orders
#
#  id                     :bigint           not null, primary key
#  guid                   :string           not null
#  status                 :integer          default("pending"), not null
#  amount                 :decimal(10, 2)
#  fee                    :decimal(10, 2)
#  to_pay                 :decimal(10, 2)
#  merchant_reference     :string           not null
#  disbursement_reference :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Order < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  belongs_to :disbursement, foreign_key: :disbursement_reference, primary_key: :reference, optional: true

  enum status: { pending: 0, processed: 1, failed: 2 }

  def generate_fee
    fee = calculate_fee
    update(to_pay: (amount - fee), fee: fee)
  end

  private

  def calculate_fee
    case amount
    when 0..49.99
      amount * 0.01
    when 50..300
      amount * 0.0095
    else
      amount * 0.0085
    end
  end
end
