# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140925205413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "investments", force: true do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.integer  "number_of_shares"
    t.float    "value"
    t.float    "percentage_of_portfolio"
    t.float    "percent_change"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotes", force: true do |t|
    t.string   "trade_date"
    t.string   "open"
    t.string   "high"
    t.string   "low"
    t.string   "close"
    t.string   "volume"
    t.string   "adjusted_close"
    t.integer  "stock_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks", force: true do |t|
    t.string   "symbol"
    t.string   "ask"
    t.string   "bid"
    t.string   "last_trade_date"
    t.string   "pe_ratio"
    t.string   "average_daily_volume"
    t.string   "earnings_per_share"
    t.string   "low_52_weeks"
    t.string   "high_52_weeks"
    t.string   "one_year_target_price"
    t.string   "weeks_range_52"
    t.string   "day_value_change"
    t.string   "dividend_yield"
    t.string   "change"
    t.string   "change_in_percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.string   "order"
    t.integer  "number_of_shares"
    t.float    "price_per_share"
    t.float    "total"
    t.integer  "investment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.integer  "password_digest"
    t.float    "cash_available"
    t.float    "cash_invested"
    t.float    "cash_total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
