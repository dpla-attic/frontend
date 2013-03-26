class MapController < ApplicationController
  helper_method :permitted_params

  def show
    @search = Map.new permitted_params.term, permitted_params.filters
    @api_search_path = @search.api_search_path
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end