class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements do |t|
      t.string :reference
      t.string :merchant_reference, null: false
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :fee, precision: 10, scale: 2

      t.timestamps
    end

    add_index(:disbursements, [:reference, :merchant_reference], unique: true)
  end
end
