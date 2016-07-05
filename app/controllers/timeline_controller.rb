class TimelineController < ApplicationController
  helper_method :permitted_params

  def show
    # Get items that match current search terms and filters, and that have dates
    # starting at the year 1000.
    @search = Search.new permitted_params.term,
                         permitted_params.filters(ignore_dates: true),
                         { page_size: 0, 'sourceResource.date.after' => '1000' }
    @timeline = Timeline.new permitted_params.term,
                             permitted_params.filters(ignore_dates: true),
                             { 'sourceResource.date.after' => '1000' }
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end