class SavedListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_list,  only: [:show, :edit, :update, :destroy, :add_item]
  before_filter :load_lists, only: [:show, :index]
  before_filter :load_saved_item, only: :add_item

  def index
    @saved_item_positions = current_user.saved_item_positions
      .includes(:saved_item, :saved_list)
      .group('saved_items.id')
      .page(params[:page]).per(20)
    attach_api_items @saved_item_positions
  end

  def show
    if @list
      @saved_item_positions = @list.saved_item_positions
        .includes(:saved_item)
        .page(params[:page]).per(20)
    else
      @saved_item_positions = @unlisted.page(params[:page]).per(20)
    end
    attach_api_items @saved_item_positions
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

  def delete_item
    @item_positions = current_user
      .saved_item_positions
      .where saved_item_id: params[:item_id]
    if params[:id].present?
      @item_positions = @item_positions
        .where saved_list_id: params[:id].to_i.nonzero? ? params[:id] : nil
    end
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
      @lists = current_user.saved_lists
      @unlisted = current_user.saved_item_positions
        .includes(:saved_item)
        .where('saved_list_id' => nil)
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

    def attach_api_items(saved_items_positions)
      api_items = {}.tap do |hash|
        DPLA::Items.by_ids(saved_items_positions.map { |p| p.saved_item.item_id })
          .each { |item| hash[item.id] = item }
      end
      saved_items_positions.each do |position|
        api_item_id = position.saved_item.item_id
        position.item = api_items[api_item_id] || Item.new('id' => api_item_id)
      end
    end
end