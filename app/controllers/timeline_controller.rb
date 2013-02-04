class TimelineController < ApplicationController
  def decades
    @search = Item::Search.build params.deep_merge(start: params[:year])
  end

  def year
    @search = Item::Search.build params.deep_merge(start: params[:year])
  end
end