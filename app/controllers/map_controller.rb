class MapController < ApplicationController
  helper_method :permitted_params

  def show
    @search = Map.new permitted_params.term, permitted_params.filters
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end