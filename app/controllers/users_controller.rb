class UsersController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    @investments = @user.investments.all
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
