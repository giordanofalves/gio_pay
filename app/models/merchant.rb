class Merchant < ApplicationRecord
  has_many :orders

  enum disbursement_frequency: { daily: 0, weekly: 1, monthly: 2 }
end
