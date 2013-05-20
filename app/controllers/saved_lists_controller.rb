class SavedListsController < ApplicationController
  before_filter :authenticate_user!, except: :show
  before_filter :load_list,  only: [:show, :edit, :update, :destroy, :add_item]
  before_filter :load_lists, only: [:show, :index]
  before_filter :load_saved_item, only: :add_item
  before_filter :prepare_positions_params, only: [:delete_positions, :reorder_positions, :copy_positions, :move_positions]

  def index
    @saved_item_positions = current_user.saved_item_positions
      .includes(:saved_list, :saved_item)
      .select('DISTINCT ON (saved_item_id) *')
      .page(params[:page]).per(20)
    attach_api_items @saved_item_positions
  end

  def show
    if @list
      @saved_item_positions = @list.saved_item_positions
        .includes(:saved_item)
        .order('position ASC')
        .page(params[:page]).per(20)
    elsif user_signed_in?
      @saved_item_positions = @unlisted.page(params[:page]).per(20)
    else
      redirect_to :new_user_session
      return
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
    respond_to do |format|
      if @list.update_attributes(params[:saved_list])
        format.html { redirect_to @list }
      else
        format.html { render :edit }
      end
        format.json { render :json => @list.private? }
    end
  end

  def destroy
    @list.destroy
    redirect_to saved_lists_path
  end

  def add_item
    current_user
      .saved_item_positions
      .where(saved_item_id: @item, saved_list_id: @list).first_or_create
    redirect_to :back
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

  def delete_positions
    @positions.each do |pos|
      if pos[:item]
        current_user.saved_item_positions
          .where(saved_item_id: pos[:item])
          .delete_all
      elsif pos[:position]
        current_user.saved_item_positions
          .where(id: pos[:position])
          .delete_all
      end
    end
    render json: @positions
  end

  def reorder_positions
    @positions.each do |pos|
      position = current_user.saved_item_positions
        .where(id: pos[:position]).first
      position.update_attribute(:position, pos[:value]) if position
    end
    render json: @positions
  end

  def copy_positions
    copy_or_move_position(:copy)
  end

  def move_positions
    copy_or_move_position(:move)
  end

  def switch_status
    target_list = current_user.saved_lists.find params[:list]
    target_list.update_attribute(:private, !target_list.private) if target_list
    redirect_to :back
  end

  private

    def copy_or_move_position(flag)
      @positions.each do |pos|
        target_list = current_user.saved_lists.find params[:list] rescue nil
        next unless target_list

        original_position = current_user.saved_item_positions.find pos[:position] rescue nil
        next unless original_position

        is_duplicate = current_user.saved_item_positions
          .where(saved_item_id: original_position.saved_item, saved_list_id: target_list).present?
        next if is_duplicate

        current_user.saved_item_positions.create(
          saved_list: target_list,
          saved_item: original_position.saved_item
        )
        if (flag == :move)
          current_user.saved_item_positions
            .where(saved_item_id: original_position.saved_item, saved_list_id: original_position.saved_list)
            .delete_all
        end
      end
      render json: @positions
    end

    def load_list
      @is_my_list = true
      if params[:id].present?
        @list = current_user.saved_lists.find params[:id] rescue nil
        if @list.nil?
          @is_my_list = false
          @list = SavedList.find(params[:id]) rescue nil
        end
        render_404 unless @list
      end
    end

    def load_lists
      if user_signed_in?
        @lists = current_user.saved_lists
        @unlisted = current_user.saved_item_positions
          .includes(:saved_item)
          .where('saved_list_id' => nil)
      end
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
          .each { |item| hash[item.id] = item } rescue nil
      end
      saved_items_positions.each do |position|
        api_item_id = position.saved_item.item_id
        position.item = api_items[api_item_id] || Item.new('id' => api_item_id)
      end
    end

    def prepare_positions_params
      @positions = params[:positions] ? params[:positions].map { |k,v| v } : []
    end
end