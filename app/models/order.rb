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

  enum status: { pending: 0, processed: 1, failed: 2 }
end
