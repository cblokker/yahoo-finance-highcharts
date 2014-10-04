class UsersController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    @investments = @user.investments.all
    investment_data = @user.investments.map do |investment|
      [investment.stock.symbol, investment.percentage_of_portfolio]
    end

    p sum = investment_data.sum { |i| i[1]}

    investment_data << ['cash balance', 100 - sum]

    if request.xhr?
      render json: investment_data.to_json
    else
      render :index
    end
  end

  def show
    @user = User.find(params[:id])
    @investments = @user.investments.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      @user.update(
        cash_available: 100_000,
        cash_invested: 0
      )
      redirect_to user_path(@user), notice: 'New user created.'
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :symbol)
  end
end
