# == Schema Information
#
# Table name: merchants
#
#  id                     :bigint           not null, primary key
#  guid                   :string           not null
#  reference              :string           not null
#  email                  :string
#  live_on                :datetime
#  disbursement_frequency :integer
#  minimum_monthly_fee    :decimal(10, 2)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Merchant < ApplicationRecord
  has_many :orders, foreign_key: :merchant_reference, primary_key: :reference
  has_many :disbursements, foreign_key: :merchant_reference, primary_key: :reference

  enum disbursement_frequency: { daily: 0, weekly: 1 }

  validates :guid, :reference, presence: true, uniqueness: true

  def perform_disbursements
    daily? ? perform_daily_disbursement(orders.pending) : perform_weekly_disbursement(orders.pending)
  end

  private

  def perform_daily_disbursement(orders)
    orders.group_by(&:created_at).each do |date, orders|
      process_disbursements(date, orders)
    end
  end

  def perform_weekly_disbursement(orders)
    start_week_day = live_on.strftime("%A").downcase.to_sym

    orders.group_by { |order| order.created_at.beginning_of_week(start_day = start_week_day) }.each do |date, orders|
      process_disbursements(date, orders)
    end
  end

  def process_disbursements(date, orders)
    disbursement = disbursements.create(created_at: date)

    disbursement.process_payments(orders)
  end
end
