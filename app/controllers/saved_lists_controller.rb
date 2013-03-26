class SavedListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_list,  only: [:show, :edit, :update, :destroy]
  before_filter :load_lists, only: [:show, :index, :unlisted]

  def index
  end

  def unlisted
  end

  def show
    @lists = current_user.saved_lists.all
  end

  def new
    @list = SavedList.new
  end

  def create
    @list = current_user.saved_lists.new params[:saved_list]
    if @list.save
      redirect_to saved_lists_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @list.update_attributes params[:saved_list]
      redirect_to @list
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to saved_lists_path
  end

  private

    def load_list
      if params[:id]
        @list = current_user.saved_lists.find params[:id] rescue nil
        raise ActionController::RoutingError.new('Not Found') unless @list
      end
    end

    def load_lists
      @lists = current_user.saved_lists
    end
end