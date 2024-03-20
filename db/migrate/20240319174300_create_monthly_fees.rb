class CreateMonthlyFees < ActiveRecord::Migration[7.1]
  def change
    create_table :monthly_fees do |t|
      t.string :merchant_reference, null: false
      t.date :month
      t.decimal :amount

      t.timestamps
    end
  end
end
