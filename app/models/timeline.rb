require_dependency 'dpla/items'

class Timeline < Search
  YEARS = 1000..Time.now.year

  def final_year
    year = self.years.max_by{|k,v| k}.first.to_i
    raise unless YEARS.include? year
    year
  rescue
    Time.now.year
  end

  def fields
    %w(
      id sourceResource.title isShownAt object
      sourceResource.type sourceResource.creator
      sourceResource.description sourceResource.date
      provider.name dataProvider
    )
  end

  def api_search_path
    conditions = DPLA::Conditions.new({ q: @term }.merge(@filters).merge(fields: fields))
    "#{api_base_path}/items?#{conditions}#{api_key}"
  end

  def api_item_path
    "#{api_base_path}/items?id=%&fields=#{fields.join(',')}&#{api_key}"
  end

  def years
    result.facets.year
  end

  def conditions
    facets = %w(date)
    conditions = { q: @term, facets: facets }.merge(@filters).merge(page_size: 0, facet_size: 2000)
  end

end
