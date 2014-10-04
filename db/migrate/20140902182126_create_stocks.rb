class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :ask
      t.string :bid
      t.string :last_trade_date
      t.string :pe_ratio
      t.string :average_daily_volume
      t.string :earnings_per_share
      t.string :low_52_weeks
      t.string :high_52_weeks
      t.string :one_year_target_price
      t.string :weeks_range_52
      t.string :day_value_change
      t.string :dividend_yield
      t.string :change
      t.string :change_in_percent

      t.timestamps
    end
  end
end
