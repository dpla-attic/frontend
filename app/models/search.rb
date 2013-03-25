require_dependency 'dpla/items'

class Search
  attr_reader :term, :filters, :args

  # - term is search query
  # - filters is hash with refines
  #    {subject: 'Ships', type: ['image', 'text']}
  #
  def initialize(term, filters = {})
    @term, @filters, @args = term, filters, {}
  end

  # Returns search results
  def items(args = {})
    @args = args
    results
  end

  def result(args = {})
    items(args)
  end

  # name is field e.g. :subject, :type, :lang, :before, :after, etc.
  def filters(name = nil)
    if name.present?
      @filters[name.to_sym].present? ? @filters[name.to_sym] : []
    else
      @filters
    end
  end

  def subjects
    results.facets.subject
  end

  def languages
    results.facets.language
  end

  def types
    results.facets.type
  end

  def states
    results.facets.state
  end

  def cities
    results.facets.city
  end

  def places
    results.facets.place
  end

  def count
    results.count
  end

  def api_path
    fields = %w(
      id aggregatedCHO.title aggregatedCHO.type aggregatedCHO.creator
      isShownAt.@id object.@id
      aggregatedCHO.spatial.name aggregatedCHO.spatial.coordinates
    )
    conditions = DPLA::Conditions.new({ q: @term }.merge(@filters).merge(fields: fields))
    api_url = Settings.api.url.gsub '://', "://#{Settings.api.username}:#{Settings.api.password }@"
    "#{api_url}/items?#{conditions}"
  end

  def conditions
    facets = %w(subject language type place city state)
    { q: @term, facets: facets }.merge(@filters).merge(@args)
  end

  private

    def results
      @result || @result = DPLA::Items.by_conditions(conditions)
    end

end