class TimelineController < ApplicationController
  helper_method :permitted_params

  def show
    @search = Timeline.new permitted_params.term, permitted_params.filters
  end

  def items_by_year
    @search = Timeline.new permitted_params.term, permitted_params.filters
    page = params[:page].to_i if params[:page]
    @year = params[:year] ? params[:year].to_i : Time.now.year
    @items = @search.items(@year, page || 0)
    render partial: "timeline/items", locals: { items: @items }, layout: false
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end