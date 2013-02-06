class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @item
  end
end