require_dependency 'dpla/items'

class Map

  def initialize(term, filters = {})
    @term    = term
    @filters = filters.except(:before, :after)
  end

  def subjects
    fetch_map_data if @subjects.nil?
    @subjects
  end

  def languages
    fetch_map_data if @languages.nil?
    @languages
  end

  def types
    fetch_map_data if @types.nil?
    @types
  end

  def count
    fetch_map_data if @count.nil?
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

    def fetch_map_data
      facets = %w(subject.name language.name type)
      conditions = { q: @term, facets: facets }.merge(@filters).merge(page_size: 0, facet_size: 200)
      @data = DPLA::Items.by_conditions(conditions)
      @subjects, @languages, @types = @data.facets.subject, @data.facets.language, @data.facets.type
      @count = @data.count
    end

end