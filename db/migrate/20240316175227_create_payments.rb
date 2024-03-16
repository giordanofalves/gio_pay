class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.references :disbursement, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :fee, precision: 10, scale: 2

      t.timestamps
    end
  end
end
