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

ActiveRecord::Schema[7.0].define(version: 2023_03_27_202947) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coins", force: :cascade do |t|
    t.string "gecko_coin"
    t.string "symbol"
    t.string "name"
    t.decimal "stock"
    t.float "price"
    t.float "change"
    t.integer "market_cap_rank"
    t.string "image_url"
    t.bigint "portfolio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_coins_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "portfolio_id", null: false
    t.date "date"
    t.bigint "coin_in_id"
    t.decimal "amount_in"
    t.float "amount_in_euro"
    t.float "amount_in_btc"
    t.bigint "coin_out_id"
    t.decimal "amount_out"
    t.float "amount_out_euro"
    t.float "amount_out_btc"
    t.bigint "coin_fees_id"
    t.decimal "amount_fees"
    t.float "amount_fees_euro"
    t.float "amount_fees_btc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_fees_id"], name: "index_transactions_on_coin_fees_id"
    t.index ["coin_in_id"], name: "index_transactions_on_coin_in_id"
    t.index ["coin_out_id"], name: "index_transactions_on_coin_out_id"
    t.index ["portfolio_id"], name: "index_transactions_on_portfolio_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "coins", "portfolios"
  add_foreign_key "portfolios", "users"
  add_foreign_key "transactions", "coins", column: "coin_fees_id"
  add_foreign_key "transactions", "coins", column: "coin_in_id"
  add_foreign_key "transactions", "coins", column: "coin_out_id"
  add_foreign_key "transactions", "portfolios"
end
