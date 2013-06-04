class TimelineController < ApplicationController
  helper_method :permitted_params

  def show
    @search = Search.new permitted_params.term, permitted_params.filters(ignore_dates: true), {page_size: 0}
    @timeline = Timeline.new permitted_params.term, permitted_params.filters(ignore_dates: true)
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end