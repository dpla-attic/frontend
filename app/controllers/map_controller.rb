class MapController < ApplicationController
  helper_method :permitted_params

  def show
    @search = Map.new permitted_params.term, permitted_params.filters
  end

  def items_by_spatial
    @search = Map.new permitted_params.term, permitted_params.filters
    page = params[:page].to_i if params[:page]
    @spatial = params[:lat] || 0, params[:lon] || 0, params[:radius] || 50
    @items = @search.items(@spatial, page || 0)
    render 'map/items'
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end