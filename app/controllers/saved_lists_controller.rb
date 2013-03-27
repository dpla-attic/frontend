class SavedListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_list,  only: [:show, :edit, :update, :destroy, :add_item, :remove_item]
  before_filter :load_lists, only: [:show, :index]
  before_filter :load_saved_item, only: :add_item

  def index
    @saved_items = current_user.saved_items
      .includes(:saved_lists)
      .group('saved_items.id')
      .page(params[:page]).per(20)
    attach_api_items @saved_items
  end

  def show
    @saved_items = @list.saved_items
      .page(params[:page]).per(20)
    attach_api_items @saved_items
  end

  def new
    @list = SavedList.new
  end

  def create
    @list = current_user.saved_lists.new params[:saved_list]
    if @list.save
      redirect_to saved_lists_path
    else
      render :new
    end
  end

  def update
    if @list.update_attributes params[:saved_list]
      redirect_to @list
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to saved_lists_path
  end

  def add_item
    @item_position = current_user
      .saved_item_positions
      .where(saved_item_id: @item, saved_list_id: @list).first_or_create
    if @list
      redirect_to @list
    else
      redirect_to saved_lists_path
    end
  end

  def remove_item
    @item_positions = current_user
      .saved_item_positions
      .where saved_item_id: params[:item_id]
    @item_positions = @item_positions
      .where saved_list_id: params[:id] if params[:id].present?
    @item_positions.delete_all
    redirect_to saved_lists_path
  end

  private

    def load_list
      if params[:id].present?
        @list = current_user.saved_lists.find params[:id] rescue nil
        raise ActionController::RoutingError.new('Not Found') unless @list
      end
    end

    def load_lists
      @lists = current_user.saved_lists.order('title')
    end

    def load_saved_item
      unless params[:item_id].present?
        redirect_to saved_lists_path
      end
      unless @item = SavedItem.find_by_item_id(params[:item_id])
        if DPLA::Items.by_ids(params[:item_id]).present?
          @item = SavedItem.create item_id: params[:item_id]
        else
          redirect_to saved_lists_path
        end
      end
    end

    def attach_api_items(saved_items)
      api_items = {}.tap do |hash|
        DPLA::Items.by_ids(saved_items.map &:item_id )
          .each { |item| hash[item.id] = item }
      end
      saved_items.each do |saved_item|
        saved_item.item = api_items[saved_item.item_id] || Item.new('id' => saved_item.item_id)
      end
    end
end