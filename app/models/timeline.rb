require_dependency 'dpla/items'

class Timeline

  def initialize(term, filters = {})
    @term    = term
    @filters = filters.except(:before, :after)
  end

  def subjects
    fetch_timeline_data if @subjects.nil?
    @subjects
  end

  def languages
    fetch_timeline_data if @languages.nil?
    @languages
  end

  def types
    fetch_timeline_data if @types.nil?
    @types
  end

  def years
    fetch_timeline_data if @years.nil?
    @years
  end

  def items(year = nil, page = 0)
    year ||= Time.now.year
    fetch_results(year, page)
    @results
  end

  def count
    fetch_timeline_data if @count.nil?
    @count
  end

  def filters(name = nil)
    if name.present?
      @filters[name.to_sym].present? ? @filters[name.to_sym] : []
    else
      @filters
    end
  end

  private

    def fetch_timeline_data
      facets = %w(subject language type date)
      conditions = { q: @term, facets: facets }.merge(@filters).merge(page_size: 0, facet_size: 2000)
      @data = DPLA::Items.by_conditions(conditions)
      @subjects, @languages, @types = @data.facets.subject, @data.facets.language, @data.facets.type
      @years = @data.facets.year
      @count = @data.count
    end

    def fetch_results(year, page)
      facets = []
      filters = @filters.merge({after: year, before: year})
      conditions = { q: @term, facets: facets }.merge(filters).merge(page: page)
      @data = DPLA::Items.by_conditions(conditions)
      @results = @data
    end
end