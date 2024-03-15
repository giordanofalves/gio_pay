class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :guid
      t.integer :status, null: false, default: 0
      t.references :merchant, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
    add_index :orders, :guid, unique: true
  end
end
