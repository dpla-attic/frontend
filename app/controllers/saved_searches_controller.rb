class SavedSearchesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @saved_searches = current_user.saved_searches.page(params[:page]).per(20)
  end

  def create
    @saved_search = current_user.saved_searches.new(term: permitted_params.term,
                        filters: permitted_params.filters)
    @saved_search.count = List.new(*permitted_params.search).result.count # TODO: more light way needed
    @saved_search.save
    redirect_to saved_searches_path
  end

  def destroy
    @search = SavedSearch.find(params[:id])
    @search.destroy
    redirect_to saved_searches_path
  end

  def destroy_bulk
    SavedSearch.where(:id => params[:ids]).destroy_all
    redirect_to saved_searches_path
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params)
    end
end
