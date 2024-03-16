require 'rails_helper'

RSpec.describe 'rake import:merchants[spec/fixtures/merchants_test.csv]' do


  # todo: task is not understanding when we pass the file_path as param
  xit "imports merchants from a CSV file" do
    task.execute
    expect(Merchant.count).to eq(2)
  end
end
