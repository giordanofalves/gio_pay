# == Schema Information
#
# Table name: orders
#
#  id                 :bigint           not null, primary key
#  guid               :string           not null
#  status             :integer          default("pending"), not null
#  merchant_reference :string           not null
#  amount             :decimal(10, 2)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Order < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  has_one :payment

  enum status: { pending: 0, processed: 1, failed: 2 }

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
