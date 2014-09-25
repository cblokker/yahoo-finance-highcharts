class InvestmentsController < ApplicationController
  def index
    p stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
  end

  def show
  end

  def new
  end

  def create
    @user = User.find(session[:user_id]) if session[:user_id]

    stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)

    Investment.create(
      stock: @stock,
      user: @user
    )

    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find(session[:user_id]) if session[:user_id]
    stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    @investment = Investment.find_by(stock: @stock).destroy

    redirect_to user_path(@user)
  end

  private
  def investment_params
    params.require(:investment).permit(:symbol)
  end
end
