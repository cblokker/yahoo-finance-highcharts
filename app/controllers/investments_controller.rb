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
    p @stock = Stock.find_by(symbol: stock_symbol)

    Investment.create(
      stock: @stock,
      user: @user
    )

    # @user.investment.create(stock: @stock)



    # # # @user = User.find(investment_params[:user_id])

    # # # @user.investment.create(stock: @stock)

    # # render :index

    # respond_to do |format|
    #   format.js
    # end


    # if request.xhr?
    #   render json: @stock.to_json
    # else
      render :index
    # end
  end
  
  private
  def investment_params
    params.require(:investment).permit(:symbol)
  end

end
