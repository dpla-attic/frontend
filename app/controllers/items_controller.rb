class ItemsController < ApplicationController
  def show
    @item = DPLA::Items.by_ids(params[:id]).first
    raise ActionController::RoutingError.new('Not Found') unless @item

    item_lists = current_user.saved_items
      .includes(:saved_lists)
      .where(item_id: 'cec24549a51b9a4413779cab8fc31713')
      .group('saved_lists.id')
      .map { |i| i.saved_lists }
      .flatten
      .compact
    @lists = current_user.saved_lists - item_lists
  end
end