class TransactionsController < ApplicationController
  def index


  end

  def show
  end

  def new
  end

  def create
    @user = User.find(session[:user_id]) if session[:user_id]
    stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)


    redirect_to user_path(@user)
  end

  def update

    redirect_to user_path(@user)
  end


  def destroy

    redirect_to user_path(@user)
  end
end
