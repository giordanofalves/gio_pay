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
require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
    it { should belong_to(:disbursement).optional }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, processed: 1, failed: 2) }
  end

  describe 'callbacks' do
    describe 'after_create' do
      it 'should generate 0.01% fee and update to_pay and fee attributes' do
        order = create(:order, amount: 49)

        expect(order.to_pay).to eq(order.amount - order.fee)
        expect(order.fee).to eq((order.amount * 0.01).round(2))
      end

      it 'should generate 0.95% fee and update to_pay and fee attributes' do
        order = create(:order, amount: 50)

        expect(order.to_pay).to eq(order.amount - order.fee)
        expect(order.fee).to eq((order.amount * 0.0095).round(2))
      end

      it 'should generate 0.85% fee and update to_pay and fee attributes' do
        order = create(:order, amount: 300)

        expect(order.to_pay).to eq(order.amount - order.fee)
        expect(order.fee).to eq((order.amount * 0.0085).round(2))
      end
    end
  end

  describe 'class methods' do
    describe '.calculate_fee' do
      it 'should calculate the fee based on the amount value' do
        expect(Order.calculate_fee(25)).to eq(0.25) # 25 * 0.01
        expect(Order.calculate_fee(100)).to eq(0.95) # 100 * 0.0095
        expect(Order.calculate_fee(500)).to eq(4.25) # 500 * 0.0085
      end
    end
  end
end
