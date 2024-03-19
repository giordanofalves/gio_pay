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

    describe '#check_previous_monthly_fee' do
      let(:merchant) { create(:merchant) }
      let(:disbursement) { create(:disbursement, merchant: merchant) }

      context 'when there are previous records on the same month' do
        before do
          create(:disbursement, merchant: merchant, created_at: disbursement.created_at - 1.day)
        end

        it 'does not create a new monthly fee' do
          expect { disbursement }.not_to change { merchant.monthly_fees.count }
        end
      end

      context 'when there are no previous records on the same month' do
        context 'when there are no disbursements in the previous month' do
          it 'does not create a new monthly fee' do
            expect { disbursement }.not_to change { merchant.monthly_fees.count }
          end
        end

        context 'when there are disbursements in the previous month' do
          let(:new_disbursement)             { build(:disbursement, merchant: merchant) }
          let!(:last_month_disbursement) { create(:disbursement, merchant: merchant, created_at: disbursement.created_at - 1.month) }

          context 'when the total disbursed last month is greater than or equal to the minimum monthly fee' do
            before do
              last_month_disbursement.update(fee: merchant.minimum_monthly_fee)
            end

            it 'does not create a new monthly fee' do
              expect { disbursement }.not_to change { merchant.monthly_fees.count }
            end
          end

          context 'when the total disbursed last month is less than the minimum monthly fee' do
            before do
              last_month_disbursement.update(fee: merchant.minimum_monthly_fee - 100)
            end

            xit 'creates a new monthly fee with the remaining amount' do
              expect { new_disbursement.save }.to change { merchant.monthly_fees.count }.by(1)
              expect(merchant.monthly_fees.last.month).to eq(disbursement.created_at.beginning_of_month)
              expect(merchant.monthly_fees.last.amount).to eq(merchant.minimum_monthly_fee - last_month_disbursement.fee)
            end
          end
        end
      end
    end
  end
end
