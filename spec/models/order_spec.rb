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
require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, processed: 1, failed: 2) }
  end
end
