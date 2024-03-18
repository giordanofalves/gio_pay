require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant).with_foreign_key(:merchant_reference).with_primary_key(:reference) }
    it { should have_many(:orders).with_foreign_key(:disbursement_reference).with_primary_key(:reference) }
  end

  describe 'methods' do
    let(:disbursement) { create(:disbursement) }
    let(:orders_data) { [create(:order), create(:order)] }

    describe '#process_orders' do
      it 'generates fees for each order' do
        disbursement.process_orders(orders_data.map(&:id))
        orders_data.each { |order| expect(order.reload.fee).to be_present }
      end

      it 'updates the amount and fee attributes' do
        disbursement.process_orders(orders_data.map(&:id))
        expect(disbursement.reload.amount).to eq(orders_data.sum(&:to_pay))
        expect(disbursement.reload.fee).to eq(orders_data.sum(&:fee))
      end

      it 'updates the disbursement_reference and status attributes for each order' do
        disbursement.process_orders(orders_data.map(&:id))
        orders_data.each do |order|
          expect(order.reload.disbursement_reference).to eq(disbursement.reference)
          expect(order.reload.status).to eq('processed')
        end
      end
    end

    describe '#generate_reference' do
      it 'generates a reference using SecureRandom' do
        expect(disbursement.reload.reference).to be_present
      end
    end
  end
end
