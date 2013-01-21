class ItemsController < ApplicationController
  def search
    @items = Item.where params
  end

  def show
    @item = Item.find(params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @item
  end
end