class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants do |t|
      t.string :guid, null: false
      t.string :reference, null: false
      t.string :email
      t.datetime :live_on
      t.integer :disbursement_frequency
      t.decimal :minimum_monthly_fee, precision: 10, scale: 2

      t.timestamps
    end

    add_index :merchants, [:guid, :reference], unique: true
  end
end
