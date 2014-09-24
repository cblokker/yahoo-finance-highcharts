class InvestmentsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
    p stock_symbol = investment_params[:symbol].upcase
    p @stock = Stock.find_by(symbol: stock_symbol)

    if request.xhr?
      render json: @stock.to_json
    else
      render :index
    end
  end

  private
  def investment_params
    params.require(:investment).permit(:symbol)
  end

end
