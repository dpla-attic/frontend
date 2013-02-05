class SearchController < ApplicationController
  def list
    @search = Search.build params
    session[:last_query] = request.url
  end

  def timeline
  	@search = Search.build params.deep_merge(start: params[:year])
  end

  def timeline_year
  	@search = Search.build params.deep_merge(start: params[:year])
  end
end
