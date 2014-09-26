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
        user: @user
      )

      @transaction = Transaction.create(
        number_of_shares: investment_params[:number_of_shares].to_i,
        price_per_share: @stock.ask.to_i,
        total: value,
        # type: "buy",
        investment: @investment
      )
    else
      # @investment[0].number_of_shares += investment_params[:number_of_shares].to_i
      # @investment[0].value += value
      # @investment[0].save

      Transaction.create(
        number_of_shares: investment_params[:number_of_shares].to_i,
        price_per_share: @stock.ask.to_i,
        total: value,
        # type: "buy",
        investment: @investment[0]
      )
    end

    cash_available = @user.cash_available - value
    cash_invested = @user.cash_invested + value
    @user.update_attribute(:cash_available, cash_available)
    @user.update_attribute(:cash_invested, cash_invested)

    redirect_to user_path(@user)
  end

  def update
    @user = User.find(session[:user_id]) if session[:user_id]
    stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    value = investment_params[:number_of_shares].to_i * @stock.ask.to_i
    @investment = Investment.where("stock_id = ? AND user_id = ?", @stock.id, @user.id)

    p @user

    cash_available = @user.cash_available - value
    cash_invested = @user.cash_invested + value
    @user.update_attribute(:cash_available, cash_available)
    @user.update_attribute(:cash_invested, cash_invested)

    @investment[0].number_of_shares += investment_params[:number_of_shares].to_i
    @investment[0].value += value
    @investment[0].save

    redirect_to user_path(@user)
  end


  def destroy
    @user = User.find(session[:user_id]) if session[:user_id]
    stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    value = investment_params[:number_of_shares].to_i * @stock.ask.to_i
    @investment = Investment.where("stock_id = ? AND user_id = ?", @stock.id, @user.id)

    if investment_params[:number_of_shares].to_i <= @investment[0].number_of_shares
      @investment[0].number_of_shares -= investment_params[:number_of_shares].to_i
      @investment[0].value -= value
      @investment[0].save

      if @investment[0].value == 0
        @investment[0].destroy
      end

      cash_available = @user.cash_available + value
      cash_invested = @user.cash_invested - value
      @user.update_attribute(:cash_available, cash_available)
      @user.update_attribute(:cash_invested, cash_invested)
    else

    end

    redirect_to user_path(@user)
  end

  private
  def investment_params
    params.require(:investment).permit(:symbol, :number_of_shares)
  end
end
