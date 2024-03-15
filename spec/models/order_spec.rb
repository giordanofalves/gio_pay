require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, processed: 1, failed: 2) }
  end
end
