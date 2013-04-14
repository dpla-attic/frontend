class PagesController < ApplicationController
  before_filter :add_about_breadcrumb, except: :home

  def home
    @apps = App.where(is_promo: true).limit(2)
  end

  def overview
    add_breadcrumb 'Overview', about_overview_path
  end

  private

  def add_about_breadcrumb
    add_breadcrumb 'About', about_root_path
  end
end
