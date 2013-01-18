class ItemsController < ApplicationController
  def search
    @items = Item.where params
  end

  def show
  end
end