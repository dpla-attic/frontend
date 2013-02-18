require_dependency 'dpla/search'

class TimelineController < ApplicationController
  def index
    @search = Timeline.new permitted_params.term, permitted_params.filters
    @year = params[:year] ? params[:year].to_i : Time.now.year
    @items = @search.items(@year)
  end

  def show
    @search = Timeline.new permitted_params.term, permitted_params.filters
    page = params[:page].to_i if params[:page]
    @year = params[:year] ? params[:year].to_i : Time.now.year
    @items = @search.items(@year, page || 0)
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

end