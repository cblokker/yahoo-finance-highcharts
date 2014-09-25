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
    value = investment_params[:number_of_shares].to_i * @stock.ask.to_i

    p @investment = Investment.where("stock_id = ? AND user_id = ?", @stock.id, @user.id)

    if @investment.blank?
      @investment = Investment.create(
        stock: @stock,
        user: @user,
        number_of_shares: investment_params[:number_of_shares].to_i,
        value: value
      )
    else
      @investment[0].number_of_shares += investment_params[:number_of_shares].to_i
      @investment[0].value += value
      @investment[0].save
    end

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
    params.require(:investment).permit(:symbol, :number_of_shares)
  end
end
