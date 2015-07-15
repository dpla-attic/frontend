require_dependency 'dpla/items'
##
# A model that represents a Book item retrieved from the search.
#
# For displaying the books in BookshelfController.
# Search#conditions is overridden to forego the retrieval of facets.
#
# @see BookshelfController
#
class Bookshelf < Search

  def conditions
    { q: @term, facets: [], facet_size: 0 }.merge(@filters).merge(@args)
  end
end
