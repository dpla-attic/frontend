class SavedItemsController < ApplicationController
  before_filter :authenticate_user!
end