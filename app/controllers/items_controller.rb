class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @item
  end
end