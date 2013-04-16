class ItemsController < ApplicationController
  before_filter :save_location

  def show
    @item = DPLA::Items.by_ids(params[:id]).first
    return render_404 unless @item

    @show_unlisted = true
    if user_signed_in?
      item_lists = current_user.saved_lists
        .includes(:saved_items)
        .where('saved_items.item_id' => params[:id])
      @lists = current_user.saved_lists - item_lists

      @show_unlisted = !current_user.saved_items
        .includes(:saved_item_positions)
        .exists?('saved_items.item_id' => params[:id], 'saved_item_positions.saved_list_id' => nil)
    end
  end

  private

    def save_location
      session[:user_return_to] = request.fullpath unless current_user
    end
end