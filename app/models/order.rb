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

  scope :by_day, ->{ group_by(&:created_at).sort  }
  scope :by_week_day, ->(start) { group_by { |o| o.created_at.beginning_of_week(start) }.sort  }

  after_create :generate_fee

  def generate_fee
    fee = self.class.calculate_fee(amount)
    update(to_pay: (amount - fee), fee: fee)
  end

  def self.calculate_fee(amout_value)
    case amout_value
    when 0..49.99
      (amout_value * 0.01).round(2)
    when 50..299.99
      (amout_value * 0.0095).round(2)
    else
      (amout_value * 0.0085).round(2)
    end
  end
end
