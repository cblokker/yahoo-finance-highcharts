class TransactionsController < ApplicationController
  def index

  end

  def show
  end

  def new
  end

  def create

    redirect_to user_path(@user)
  end

  def update

    redirect_to user_path(@user)
  end


  def destroy

    redirect_to user_path(@user)
  end
end
