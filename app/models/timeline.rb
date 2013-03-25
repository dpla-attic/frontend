require_dependency 'dpla/items'

class Timeline < Search

  def years
    result.facets.year
  end

  def conditions
    facets = %w(subject language type place city state date)
    conditions = { q: @term, facets: facets }.merge(@filters).merge(page_size: 0, facet_size: 2000)
  end

end