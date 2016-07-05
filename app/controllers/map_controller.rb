class MapController < ApplicationController
  helper_method :permitted_params

  def show
    # Get items that match current search terms and filters, and that have
    # spatial coordinates.
    @search = Map.new permitted_params.term,
                      permitted_params.filters,
                      { page_size: 0,
                        'sourceResource.spatial.coordinates' => '90,-179.99:-90,180' }
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end