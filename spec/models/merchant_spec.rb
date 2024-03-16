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
  end

  describe 'enums' do
    it { should define_enum_for(:disbursement_frequency).with_values(daily: 0, weekly: 1, monthly: 2) }
  end
end
