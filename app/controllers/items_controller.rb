class ItemsController < ApplicationController
  def show
    @item = DPLA::Items.by_ids(params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @item

    item_lists = current_user.saved_lists
      .includes(:saved_items)
      .where('saved_items.item_id' => params[:id])
    @lists = current_user.saved_lists - item_lists
  end
end