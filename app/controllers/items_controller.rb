class ItemsController < ApplicationController
  before_filter :save_location

  def show
    @item = DPLA::Items.by_ids(params[:id]).first
    return render_404 unless @item
    @next = is_integer?(params[:next]) ? params[:next] : nil
    @previous = is_integer?(params[:previous]) ? params[:previous] : nil
    respond_to do |format|
      format.html do
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
      format.json { render json: @item }
    end
  end

  ##
  # Get the next item from a search query and render it in the show view.
  # params must include:
  #   back_uri: the URI of the search results
  #   position: the position in the search results sequence of the next item
  def next
    @back_uri = params[:back_uri]
    render_404 and return unless @back_uri.present?

    @position = params[:position]
    render_404 and return unless @position.present?

    @search_params = back_uri_params
    render_500 and return if @search_params.nil?
    update_search_params_page

    items = search_items || []
    @item = items[index] rescue nil
    render_404 and return unless @item.present?
    redirect_to action: :show, id: @item.id,
                               back_uri: @back_uri,
                               next: items.position_after(index),
                               previous: items.position_before(index)
  end

  ##
  # Get the previous item from a search query and render it in the show view.
  # params must include:
  #   back_uri: the URI of the search results
  #   position: the position in the search results sequence of the previous item
  def previous
    @back_uri = params[:back_uri]
    render_404 and return unless @back_uri.present?

    @position = params[:position]
    render_404 and return unless @position.present?

    @search_params = back_uri_params
    render_500 and return if @search_params.nil?
    update_search_params_page

    items = search_items || []
    @item = items[index] rescue nil
    render_404 and return unless @item.present?
    redirect_to action: :show, id: @item.id,
                               back_uri: @back_uri,
                               next: items.position_after(index),
                               previous: items.position_before(index)
  end

  private

  def save_location
    session[:user_return_to] = request.fullpath unless current_user
  end

  ##
  # Tests whether or not a string can be converted to a base-10 integer.
  # @param [String] || nil
  def is_integer?(string)
    string.to_i.to_s == string
  end

  ##
  # Parses query params from params[:back_uri]
  # @return [Hash] with indifferent access
  #   Hash must have indifferent access for use in PermittedParams
  # @return nil if params[:back_uri] is either not present or invalid URI
  def back_uri_params
    back_uri = URI.parse(@back_uri) rescue nil
    return nil unless back_uri.present?
    Rack::Utils.parse_nested_query(back_uri.query).with_indifferent_access
  end

  ##
  # @return [Integer]
  def page_size
    page_size = @search_params['page_size'] || 20
    page_size.to_i
  end

  def index
    @position.to_i % page_size
  end

  def update_search_params_page
    page = (@position.to_i / page_size).ceil + 1
    @search_params['page'] = page.to_s
  end

  ##
  # @param [Hash]
  # @return [DPLA::Result] (ie. [Enumerable<Item>]) || nil
  def search_items
    return nil unless defined? @search_params
    permitted_params = PermittedParams.new(@search_params)
    search = Search.new *permitted_params.search
    search.result permitted_params.args
  end
end
