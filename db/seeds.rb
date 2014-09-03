require 'yahoo_finance'

stocks = ['AAPL', 'NFLX', 'LULU', 'LUV', 'GILD', 'TSLA']

data = YahooFinance.historical_quotes('AAPL', Time::now - (24 * 60 * 60 * 60 * 10), Time::now)

apple = Stock.create(symbol: 'AAPL')

data.each do |d|
  Quote.create(
    stock: apple,
    close: d.close,
    volume: d.volume,
    trade_date: d.trade_date
  )
end
