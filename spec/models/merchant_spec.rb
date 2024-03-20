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
require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many(:orders) }
    it { should have_many(:disbursements) }
  end

  describe 'enums' do
    it { should define_enum_for(:disbursement_frequency).with_values(daily: 0, weekly: 1) }
  end

  describe 'validations' do
    it { should validate_presence_of(:guid) }
    it { should validate_presence_of(:reference) }
    it { should validate_uniqueness_of(:guid) }
    it { should validate_uniqueness_of(:reference) }
  end

  describe 'methods' do
    let(:merchant) { create(:merchant) }

    describe '#perform_disbursements' do
      let!(:orders) { create_list(:order, 3, merchant_reference: merchant.reference).sort}

      context 'when disbursement_frequency is daily' do
        before { merchant.update(disbursement_frequency: :daily) }

        it 'calls perform_daily_disbursement method' do
          expect(merchant).to receive(:perform_daily_disbursement).with(orders)
          merchant.perform_disbursements
        end
      end

      context 'when disbursement_frequency is weekly' do
        before { merchant.update(disbursement_frequency: :weekly) }

        it 'calls perform_weekly_disbursement method' do
          expect(merchant).to receive(:perform_weekly_disbursement).with(orders)
          merchant.perform_disbursements
        end
      end
    end

    describe '#perform_daily_disbursement' do
      let(:daily_merchant) { create(:merchant) }
      let!(:order1)        { create(:order, merchant_reference: daily_merchant.reference, created_at: 1.day.ago.to_date) }
      let!(:order2)        { create(:order, merchant_reference: daily_merchant.reference, created_at: 1.day.ago.to_date) }
      let!(:order3)        { create(:order, merchant_reference: daily_merchant.reference, created_at: 2.days.ago.to_date) }

      before do
        @day1_orders = daily_merchant.orders.where(created_at: 1.day.ago.to_date).select(:id, :created_at).to_a
        @day2_orders = daily_merchant.orders.where(created_at: 2.days.ago.to_date).select(:id, :created_at).to_a
      end

      it 'calls process_disbursements for each date' do
        expect(daily_merchant).to receive(:process_disbursements).with(1.day.ago.beginning_of_day, @day1_orders)
        expect(daily_merchant).to receive(:process_disbursements).with(2.days.ago.beginning_of_day, @day2_orders)
        daily_merchant.perform_disbursements
      end
    end

    describe '#perform_weekly_disbursement' do
      let!(:weekly_merchant) { create(:merchant, :weekly) }
      let!(:order1)          { create(:order, merchant_reference: weekly_merchant.reference, created_at: 1.week.ago.to_date) }
      let!(:order2)          { create(:order, merchant_reference: weekly_merchant.reference, created_at: 1.week.ago.to_date) }
      let!(:order3)          { create(:order, merchant_reference: weekly_merchant.reference, created_at: 2.weeks.ago.to_date) }


      before do
        @week1_orders = weekly_merchant.orders.where(created_at: 1.week.ago.to_date).select(:id, :created_at).to_a
        @week2_orders = weekly_merchant.orders.where(created_at: 2.weeks.ago.to_date).select(:id, :created_at).to_a
      end

      it 'calls process_disbursements for each week' do
        start_week_day = weekly_merchant.live_on.strftime("%A").downcase.to_sym

        expect(weekly_merchant).to receive(:process_disbursements).with(1.week.ago.beginning_of_week(start_day = start_week_day), @week1_orders)
        expect(weekly_merchant).to receive(:process_disbursements).with(2.weeks.ago.beginning_of_week(start_day = start_week_day), @week2_orders)
        weekly_merchant.perform_disbursements
      end
    end
  end
end
