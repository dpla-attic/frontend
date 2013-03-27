class SavedItemsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @item = current_user.saved_items.new params.slice :item_id, :saved_list_id
    if @item.saved_list.present? && @item.save
      redirect_to saved_list_path @item.saved_list
    else
      redirect_to params[:item_id] ? item_path(params[:item_id]) : search_path
    end
  end
end