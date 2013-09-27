require_dependency 'dpla/items'

class Search
  attr_reader :term, :filters, :args

  # - term is search query
  # - filters is hash with refines
  #    {subject: 'Ships', type: ['image', 'text']}
  #
  def initialize(term, filters = {}, args = {})
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

  def providers
    results.facets.provider
  end

  def partners
    results.facets.partner
  end

  def countries
    results.facets.country
  end

  def states
    results.facets.state
  end

  def places
    results.facets.place
  end

  def count
    results.count
  end

  def api_base_path
    api_path = Settings.api.url
    if Settings.api.username && Settings.api.password
      api_path = api_path.gsub '://', "://#{Settings.api.username}:#{Settings.api.password }@"
    end
    api_path
  end

  def api_key
    "&api_key=#{Settings.api.key}" if Settings.api.key
  end

  def api_search_path
    fields = %w(
      id sourceResource.title isShownAt object
      sourceResource.type sourceResource.creator
      sourceResource.spatial.name sourceResource.spatial.coordinates
    )
    conditions = DPLA::Conditions.new({ q: @term }.merge(@filters).merge(fields: fields))
    "#{api_base_path}/items?#{conditions}#{api_key}"
  end

  def app_search_path
    Hash[@filters.map {|k,v| [k, Array(v)] }].to_query
  end

  def conditions
    facets = %w(subject language type provider partner country state place)
    { q: @term, facets: facets, facet_size: 150 }.merge(@filters).merge(@args)
  end

  private

    def results
      @result || @result = DPLA::Items.by_conditions(conditions)
    end

end