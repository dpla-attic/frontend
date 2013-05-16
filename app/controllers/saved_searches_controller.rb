class SavedSearchesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_id_params, only: [:destroy_bulk]


  def index
    @saved_searches = current_user.saved_searches.page(params[:page]).per(20)
    @saved_searches = @saved_searches.reorder("term #{params[:sort]}") if params[:sort].present? and ['desc', 'asc'].include?(params[:sort].downcase)
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
    @id_params.each do |id_param|
      current_user.saved_searches
        .where(id: id_param[:id])
        .delete_all
    end

    redirect_to saved_searches_path
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end

    def prepare_id_params
      @id_params = params[:ids] ? params[:ids].map { |k,v| v } : []
    end

end
