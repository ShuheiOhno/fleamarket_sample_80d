class UsersController < ApplicationController
  before_action :set_mypage, only: [:exhibiting, :sold]

  def show
    @items = Item.where(buyer_id: current_user.id).page(params[:page]).per(5)
  end

  def exhibiting
    
  end

  def sold
    
  end

  def set_mypage
    @items = Item.where(seller_id: current_user.id).page(params[:page]).per(5)
  end
end