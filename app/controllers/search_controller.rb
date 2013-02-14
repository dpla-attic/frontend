require_dependency 'dpla/search'

class SearchController < ApplicationController
  def list
    @search = DPLA::Search.new *permitted_params.search
    @items = @search.result permitted_params.args
    session[:last_query] = request.url
  end

  def timeline
    @search = Timeline.new permitted_params.term, permitted_params.filters
  end

  def timeline_year
    @search = Timeline.new permitted_params.term, permitted_params.filters
    @items = @search.items(2000)
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end
