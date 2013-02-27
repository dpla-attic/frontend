class SearchController < ApplicationController
  def list
    @search = Search.new *permitted_params.search
    @items = @search.result permitted_params.args
    session[:last_query] = request.url
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end
