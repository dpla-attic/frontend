class ItemsController < ApplicationController
  def show
    @item = DPLA::Items.by_ids(params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @item
  end
end