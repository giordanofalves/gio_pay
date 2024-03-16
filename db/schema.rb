# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_16_175227) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disbursements", force: :cascade do |t|
    t.string "reference"
    t.string "merchant_reference", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "fee", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference", "merchant_reference"], name: "index_disbursements_on_reference_and_merchant_reference", unique: true
  end

  create_table "merchants", force: :cascade do |t|
    t.string "guid", null: false
    t.string "reference", null: false
    t.string "email"
    t.datetime "live_on"
    t.integer "disbursement_frequency"
    t.decimal "minimum_monthly_fee", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "reference"], name: "index_merchants_on_guid_and_reference", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.string "guid", null: false
    t.integer "status", default: 0, null: false
    t.string "merchant_reference", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "merchant_reference"], name: "index_orders_on_guid_and_merchant_reference", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "disbursement_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "fee", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disbursement_id"], name: "index_payments_on_disbursement_id"
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  add_foreign_key "payments", "disbursements"
  add_foreign_key "payments", "orders"
end
