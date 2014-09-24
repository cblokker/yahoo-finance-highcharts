class StocksController < ApplicationController
  def index
  end

  def new
  end


  def create
    stock_symbol = params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    time_since_stock_updated = @stock.stock_last_updated_at if @stock
    @time_limit = 100

    if params[:time_limit] != ""
      @time_limit = params[:time_limit].to_i
    end

    # create stock and seed history data
    if @stock.nil?
      @stock = Stock.create_stock_data(stock_symbol)
    elsif time_since_stock_updated <= 1
      @stock = Stock.update_stock_data(@stock)
    end

    stock_quotes = @stock.quotes.limit(@time_limit)
    # @past_stock_data = stock_quotes.map { |stock_quote| stock_quote }

    p "Stock Quotes: #{stock_quotes}"
    p "Past Stock data: #{@past_stock_data}"

    if request.xhr?
      render json: {
        currentStockData: @stock,
        pastStockData: stock_quotes
      }.to_json
    else
      render :index
    end
  end
end
