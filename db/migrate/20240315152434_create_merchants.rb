class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants do |t|
      t.string :guid
      t.string :reference
      t.string :email
      t.datetime :live_on
      t.integer :disbursement_frequency
      t.decimal :minimum_monthly_fee

      t.timestamps
    end
    add_index :merchants, :guid, unique: true
    add_index :merchants, :reference, unique: true
  end
end
