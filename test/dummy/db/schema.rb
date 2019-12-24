# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_30_045724) do

  create_table "omni_account_account_histories", force: :cascade do |t|
    t.integer "account_id"
    t.integer "entry_id"
    t.integer "previous_id"
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.decimal "balance", precision: 12, scale: 2, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.index ["account_id"], name: "index_omni_account_account_histories_on_account_id"
    t.index ["entry_id"], name: "index_omni_account_account_histories_on_entry_id"
    t.index ["previous_id", "account_id"], name: "index_omni_account_histories_on_previous_and_account", unique: true
  end

  create_table "omni_account_accounts", force: :cascade do |t|
    t.string "holder_type"
    t.integer "holder_id"
    t.string "name"
    t.integer "normal_balance"
    t.decimal "balance", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["holder_id", "holder_type", "name"], name: "index_omni_account_accounts_on_holder_and_name", unique: true
    t.index ["normal_balance"], name: "index_omni_account_accounts_on_normal_balance"
  end

  create_table "omni_account_entries", force: :cascade do |t|
    t.string "origin_type"
    t.integer "origin_id"
    t.string "uid"
    t.text "description"
    t.datetime "created_at", null: false
    t.index ["origin_type", "origin_id"], name: "index_omni_account_entries_on_origin_type_and_origin_id"
    t.index ["uid"], name: "index_omni_account_entries_on_uid", unique: true
  end

end
