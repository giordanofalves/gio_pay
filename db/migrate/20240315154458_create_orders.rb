class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :guid, null: false
      t.integer :status, null: false, default: 0
      t.string :merchant_reference, null: false
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end

    add_index(:orders, [:guid, :merchant_reference], unique: true)
  end
end
