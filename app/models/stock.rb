require 'yahoo_finance'

class Stock < ActiveRecord::Base
  has_many :quotes
  has_many :investments
  has_many :users, through: :investments

  def stock_last_updated_at
    ((Time.now - self.updated_at) / (60 * 60 * 24)).round
  end


  def self.create_stock_data(stock_symbol)
    current_stock_data = Stock.yahoo_current_stock_data(stock_symbol)

    if current_stock_data[0].ask != "N/A"
      @stock = Stock.create_stock(current_stock_data)
      quotes = Stock.generate_historical_quotes_by_date(24 * 60 * 60 * 60 * 300, stock_symbol)
      Stock.generate_quotes(quotes, @stock)
      return @stock
    end
  end


  def self.update_stock_data(stock)
    quotes = Stock.generate_historical_quotes_by_date(24 * 60 * 60, stock.symbol)
    Stock.generate_quotes(quotes, stock)
    stock
  end


  private
  def self.create_stock(current_stock_data)
    Stock.create(
      symbol:                current_stock_data[0].symbol,
      ask:                   current_stock_data[0].ask,
      bid:                   current_stock_data[0].bid,
      last_trade_date:       current_stock_data[0].last_trade_date,
      pe_ratio:              current_stock_data[0].pe_ratio,
      average_daily_volume:  current_stock_data[0].average_daily_volume,
      earnings_per_share:    current_stock_data[0].earnings_per_share,
      low_52_weeks:          current_stock_data[0].low_52_weeks,
      high_52_weeks:         current_stock_data[0].high_52_weeks,
      one_year_target_price: current_stock_data[0].one_year_target_price,
      weeks_range_52:        current_stock_data[0].weeks_range_52,
      day_value_change:      current_stock_data[0].day_value_change,
      dividend_yield:        current_stock_data[0].dividend_yield,
      change_in_percent:     current_stock_data[0].change_in_percent,
      change:                current_stock_data[0].change
    )
  end


  def self.yahoo_current_stock_data(stock_symbol)
    YahooFinance.quotes(
      [stock_symbol],
      [
        :ask,
        :bid,
        :last_trade_date,
        :pe_ratio,
        :average_daily_volume,
        :earnings_per_share,
        :low_52_weeks,
        :high_52_weeks,
        :one_year_target_price,
        :weeks_range_52,
        :day_value_change,
        :dividend_yield,
        :change_in_percent,
        :change
      ]
    )
  end


  def self.generate_historical_quotes_by_date(date, stock_symbol)
    YahooFinance.historical_quotes(
      stock_symbol,
      Time::now - date,
      Time::now
    )
  end


  def self.generate_quotes(quoters, stock)
    quoters.each do |quote|
      stock.quotes.create(
        trade_date:     quote.trade_date,
        open:           quote.open,
        high:           quote.high,
        low:            quote.low,
        close:          quote.close,
        volume:         quote.volume,
        adjusted_close: quote.adjusted_close
      )
    end
  end
end
