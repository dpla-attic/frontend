class PartnersController < ApplicationController
  def index
    search = Search.new nil, { facets: %w(partner), page_size: 0, facet_size: 500 }
    @partners = search.result.facets.partner
  end
end
