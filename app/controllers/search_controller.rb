class SearchController < ApplicationController
  def list
    @search = Search.build params
    session[:last_query] = request.url
  end

  def timeline
  end
end
