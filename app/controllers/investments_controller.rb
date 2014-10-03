class InvestmentsController < ApplicationController
  def index
    p stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
  end

  def show
  end

  def new
  end

      # t.belongs_to :user
      # t.belongs_to :stock
      # t.integer :number_of_shares
      # t.float :value
      # t.float :percentage_of_portfolio
      # t.float :percent_change

  def create
    @user = User.find(session[:user_id]) if session[:user_id]
    stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    value = investment_params[:number_of_shares].to_i * @stock.ask.to_i
    percentage_of_portfolio = (value / (@user.cash_available + @user.cash_invested)) * 100

    @investment = Investment.where("stock_id = ? AND user_id = ?", @stock.id, @user.id)

    if @investment.blank? && @user.cash_available > value
      @investment = Investment.create(
        stock: @stock,
        user: @user,
        number_of_shares: investment_params[:number_of_shares].to_i,
        value: value,
        percentage_of_portfolio: percentage_of_portfolio, 
        percent_change: 0.0
      )

      @transaction = Transaction.create(
        number_of_shares: investment_params[:number_of_shares].to_i,
        price_per_share: @stock.ask.to_i,
        total: value,
        order: "buy",
        investment: @investment
      )

      cash_available = @user.cash_available - value
      cash_invested = @user.cash_invested + value
      @user.update_attribute(:cash_available, cash_available)
      @user.update_attribute(:cash_invested, cash_invested)

    elsif @user.cash_available > value
      @investment[0].number_of_shares += investment_params[:number_of_shares].to_i
      @investment[0].value += value
      @investment[0].percentage_of_portfolio += percentage_of_portfolio
      @investment[0].save

      Transaction.create(
        number_of_shares: investment_params[:number_of_shares].to_i,
        price_per_share: @stock.ask.to_i,
        total: value,
        order: "buy",
        investment: @investment[0]
      )

      cash_available = @user.cash_available - value
      cash_invested = @user.cash_invested + value
      @user.update_attribute(:cash_available, cash_available)
      @user.update_attribute(:cash_invested, cash_invested)
    end



    redirect_to user_path(@user)
  end

  def update
    @user = User.find(session[:user_id]) if session[:user_id]
    stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    value = investment_params[:number_of_shares].to_i * @stock.ask.to_i
    @investment = Investment.where("stock_id = ? AND user_id = ?", @stock.id, @user.id)

    if @user.cash_available > value
      cash_available = @user.cash_available - value
      cash_invested = @user.cash_invested + value
      @user.update_attribute(:cash_available, cash_available)
      @user.update_attribute(:cash_invested, cash_invested)

      @investment[0].number_of_shares += investment_params[:number_of_shares].to_i
      @investment[0].value += value
      @investment[0].save

      Transaction.create(
        number_of_shares: investment_params[:number_of_shares].to_i,
        price_per_share: @stock.ask.to_i,
        total: value,
        order: "buy",
        investment: @investment[0]
      )
    else
      # error
    end

    redirect_to user_path(@user)
  end


  def destroy
    @user = User.find(session[:user_id]) if session[:user_id]
    stock_symbol = investment_params[:symbol].upcase
    @stock = Stock.find_by(symbol: stock_symbol)
    value = investment_params[:number_of_shares].to_i * @stock.ask.to_i
    @investment = Investment.where("stock_id = ? AND user_id = ?", @stock.id, @user.id)

    if investment_params[:number_of_shares].to_i == @investment[0].number_of_shares
      @investment[0].destroy

      cash_available = @user.cash_available + value
      cash_invested = @user.cash_invested - value
      @user.update_attribute(:cash_available, cash_available)
      @user.update_attribute(:cash_invested, cash_invested)

    elsif investment_params[:number_of_shares].to_i < @investment[0].number_of_shares
      @investment[0].number_of_shares -= investment_params[:number_of_shares].to_i
      @investment[0].value -= value
      @investment[0].save

      Transaction.create(
        number_of_shares: investment_params[:number_of_shares].to_i,
        price_per_share: @stock.ask.to_i,
        total: -value,
        order: 'sell',
        investment: @investment[0]
      )

      cash_available = @user.cash_available + value
      cash_invested = @user.cash_invested - value
      @user.update_attribute(:cash_available, cash_available)
      @user.update_attribute(:cash_invested, cash_invested)
    else
      # error
    end

    redirect_to user_path(@user)
  end

  private
  def investment_params
    params.require(:investment).permit(:symbol, :number_of_shares)
  end
end
