class ItemsController < ApplicationController
  def search
    facets = {facets: [:'subject.name']}
    @items = Item.where params.merge(facets)
  end

  def show
    @item = Item.find(params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @item
  end
end