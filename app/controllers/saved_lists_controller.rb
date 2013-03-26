class SavedListsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @list = SavedList.find params[:id]
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
    @list = SavedList.find params[:id]
  end

  def update
    @list = SavedList.find params[:id]
    if @list.update_attributes params[:saved_list]
      redirect_to @list
    else
      render :edit
    end
  end

  def destroy
  end
end