class TimelineController < ApplicationController
  def decades
    @search = Search.build params.deep_merge(start: params[:year])
  end

  def year
    @search = Search.build params.deep_merge(start: params[:year])
  end
end