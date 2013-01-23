class ItemsController < ApplicationController
  def search
    @search = Item::Search.build params
  end

  def show
    @item = Item.find(params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @item
  end
end