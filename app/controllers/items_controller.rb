class ItemsController < ApplicationController
  def search
    @search = Item::Search.build params
    session[:last_query] = request.url
  end

  def show
    @item = Item.find(params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @item
    logger.debug @item.inspect
  end
end