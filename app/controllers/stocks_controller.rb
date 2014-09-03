require 'yahoo_finance'
require "pp"

class StocksController < ApplicationController
  def index
  end

  def new
  end


  def create
    stock_symbol = params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    p time_since_stock_updated = ((Time.now - @stock.updated_at) / (60 * 60 * 24)).round if @stock

    @time_limit = 100

    if params[:time_limit] != ""
      @time_limit = params[:time_limit].to_i
    end


    # create stock and seed history data
    if @stock.nil?
      current_stock_data = YahooFinance.quotes(
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
          :dividend_yield
        ]
      )

      @stock = Stock.create(
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
        dividend_yield:        current_stock_data[0].dividend_yield
      )

      quotes = YahooFinance.historical_quotes(
        stock_symbol,
        Time::now - (24 * 60 * 60 * 60 * 300),
        Time::now
      )

      quotes.each do |quote|
        @stock.quotes.create(
          trade_date:     quote.trade_date,
          open:           quote.open,
          high:           quote.high,
          low:            quote.low,
          close:          quote.close,
          volume:         quote.volume,
          adjusted_close: quote.adjusted_close
        )
      end

    # update stock history data
    elsif time_since_stock_updated <= 1
      quotes = YahooFinance.historical_quotes(
        stock_symbol,
        Time::now - (24 * 60 * 60),
        Time::now
      )

      quotes.each do |quote|
        @stock.quotes.create(
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

    stock_quotes = @stock.quotes.limit(@time_limit)
    @past_stock_data = stock_quotes.map { |stock_quote| stock_quote }


    if request.xhr?
      render json: { currentStockData: @stock,
                     pastStockData: @past_stock_data }.to_json
    else
      render :index
    end
  end
end
