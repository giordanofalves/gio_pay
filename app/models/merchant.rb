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
    orders_data = orders.pending.select(:id, :created_at)
    daily? ? perform_daily_disbursement(orders_data) : perform_weekly_disbursement(orders_data)
  end

  private

  def perform_daily_disbursement(orders_data)
    orders_data.group_by(&:created_at).each do |date, orders|
      process_disbursements(date, orders)
    end
  end

  def perform_weekly_disbursement(orders_data)
    start_week_day = live_on.strftime("%A").downcase.to_sym

    orders_data.group_by { |order| order.created_at.beginning_of_week(start_day = start_week_day) }.each do |date, orders|
      process_disbursements(date, orders)
    end
  end

  def process_disbursements(date, orders)
    order_ids = orders.pluck(:id)

    CreateDisbursementJob.perform_later(id, date, order_ids)
  end
end
