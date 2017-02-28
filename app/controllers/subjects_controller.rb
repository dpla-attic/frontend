class SubjectsController < ApplicationController
  def index
    search = Search.new nil, { facets: %w(subject), page_size: 0, facet_size: 300 }
    @subjects = search.result.facets.subject
  end
end
