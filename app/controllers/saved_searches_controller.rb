class SavedSearchesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_positions_params, only: [:destroy_bulk]


  def index
    @saved_searches = current_user.saved_searches.page(params[:page]).per(20)
  end

  def create
    @saved_search = current_user.saved_searches.new(
      term: permitted_params.term,
      filters: permitted_params.filters
    )
    @saved_search.save
    redirect_to :back
  end

  def destroy
    @search = current_user.saved_searches.find(params[:id])
    @search.destroy
    redirect_to saved_searches_path
  end

  def destroy_bulk
    @positions.each do |pos|
      current_user.saved_searches
        .where(id: pos[:position])
        .delete_all
    end

    redirect_to saved_searches_path
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

    def prepare_positions_params
      @positions = params[:positions] ? params[:positions].map { |k,v| v } : []
    end

end
