module StocksHelper
  def stock_last_updated_at
    ((Time.now - self.updated_at) / (60 * 60 * 24)).round if self
  end


  def create_stock_data
    current_stock_data = yahoo_current_stock_data(stock_symbol)
    @stock = create_stock(current_stock_data)

    quotes = generate_historical_quotes_by_date(24 * 60 * 60 * 60 * 300)
    quotes.generate_quotes
  end


  def update_stock_data
    quotes = generate_historical_quotes_by_date(24 * 60 * 60)
    quotes.generate_quotes
  end


  def create_stock(current_stock_data)
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
      dividend_yield:        current_stock_data[0].dividend_yield
    )
  end


  def yahoo_current_stock_data(stock_symbol)
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
        :dividend_yield
      ]
    )
  end


  def generate_historical_quotes_by_date(date)
    YahooFinance.historical_quotes(
      stock_symbol,
      Time::now - date,
      Time::now
    )
  end


  def generate_quotes
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
end
