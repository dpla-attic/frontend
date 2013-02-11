require_dependency 'dpla/search'

class SearchController < ApplicationController
  def list
    @search = DPLA::Search.new *permitted_params.search
    @documents = @search.documents permitted_params.args
    session[:last_query] = request.url
  end

  def timeline
  	@search = Search.build params.deep_merge(start: params[:year])
  end

  def timeline_year
  	@search = Search.build params.deep_merge(start: params[:year])
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end
