class Order < ApplicationRecord
  belongs_to :merchant

  enum status: { pending: 0, processed: 1, failed: 2 }
end
