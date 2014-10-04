class StocksController < ApplicationController
  def index
  end

  def new
  end


  def create
    stock_symbol = params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    time_since_stock_updated = @stock.stock_last_updated_at if @stock
    @time_limit = 500

    if params[:time_limit] != ""
      @time_limit = params[:time_limit].to_i
    end

    # create stock - seed history data or update stock
    if @stock.nil?
      p "hi"
      @stock = Stock.create_stock_data(stock_symbol)
    elsif time_since_stock_updated <= 1
      p "there"
      @stock = Stock.update_stock_data(@stock)
    end

    stock_quotes = @stock.quotes.limit(@time_limit)

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
