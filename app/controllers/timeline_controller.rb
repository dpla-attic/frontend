class TimelineController < ApplicationController
  helper_method :permitted_params

  def show
    @search = Search.new permitted_params.term, permitted_params.filters(ignore_dates: true), {page_size: 0}
    @timeline = Timeline.new permitted_params.term, permitted_params.filters(ignore_dates: true)
    @api_search_path = @timeline.api_search_path
    @api_item_path   = @timeline.api_item_path

    @finalYear = @timeline.years.max_by{|k,v| k}.first
    @finalYear = Time.now.year if @finalYear.to_i > Time.now.year
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end