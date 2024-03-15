require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many(:orders) }
  end

  describe 'enums' do
    it { should define_enum_for(:disbursement_frequency).with_values(daily: 0, weekly: 1, monthly: 2) }
  end
end
