class MapController < ApplicationController
  def show
    @search = Map.new permitted_params.term, permitted_params.filters
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end