# == Schema Information
#
# Table name: disbursements
#
#  id          :bigint           not null, primary key
#  reference   :string
#  merchant_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Disbursement < ApplicationRecord
  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
  has_many :payments
  has_many :orders, through: :payments

  after_create :generate_reference

  private

  def generate_reference
    update(reference: SecureRandom.alphanumeric(10))
  end
end
