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


end
