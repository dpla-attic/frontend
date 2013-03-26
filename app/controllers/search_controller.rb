class SearchController < ApplicationController
  helper_method :permitted_params

  def show
    @search = Search.new *permitted_params.search
    @items = @search.result permitted_params.args
    @exhibitions = search_exhibitions permitted_params.term
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

    def search_exhibitions(q = nil)
      if q.present?
        exhibits = Exhibition.find_by_term q
      end
    end
end
