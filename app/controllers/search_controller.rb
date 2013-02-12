require_dependency 'dpla/search'

class SearchController < ApplicationController
  def list
    @search = DPLA::Search.new *permitted_params.search
    @items = @search.result permitted_params.args
    session[:last_query] = request.url
  end

  def timeline
    @search = DPLA::Search.new *permitted_params.search
    @graph  = DPLA::Search.new *permitted_params.search # TODO: slice 1900..2010
  end

  def timeline_year
    @search = DPLA::Search.new permitted_params.term, 
                               permitted_params.filters.deep_merge(start: params[:year])
    @items = @search.result
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end
