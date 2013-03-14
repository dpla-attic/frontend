class SavedSearchesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @saved_searches = current_user.saved_searches.page(params[:page]).per(20)
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
end
