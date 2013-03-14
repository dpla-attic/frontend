require_dependency 'dpla/items'

class Map

  def initialize(term, filters = {})
    @term    = term
    # TODO: except location filters if it present
    @filters = filters
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

  def locations
    fetch_map_data if @locations.nil?
    @locations
  end

  def states
    fetch_map_data if @states.nil?
    [].tap do |states|
      @states.each do |state, count|
        coord = State.geocode state
        states << {name: state, count: count, lat: coord.first, lng: coord.last} if coord
      end
    end
  end

  # spatial = [lat, lng, radius_in_km]
  def items(spatial, page = 0)
    fetch_results(spatial, page)
    @results
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

  def api_path
    fields = [
      'id', 'aggregatedCHO.title', 'aggregatedCHO.type', 'aggregatedCHO.creator',
      'isShownAt.@id', 'object.@id',
      'aggregatedCHO.spatial.name', 'aggregatedCHO.spatial.coordinates',
    ]
    conditions = DPLA::Conditions.new({ q: @term }.merge(@filters).merge(fields: fields))
    api_url = Settings.api.url.gsub '://', "://#{Settings.api.username}:#{Settings.api.password }@"
    "#{api_url}/items?#{conditions}"
  end

  private

    def fetch_map_data
      facets = %w(subject language type location state)
      conditions = { q: @term, facets: facets }.merge(@filters).merge(page_size: 0, facet_size: 200)
      @data = DPLA::Items.by_conditions(conditions)
      @subjects, @languages, @types, @locations, @states =
        @data.facets.subject, @data.facets.language, @data.facets.type, @data.facets.location, @data.facets.state
      @count = @data.count
    end

    def fetch_results(spatial, page)
      facets = []
      filters = @filters.merge({location: spatial[0..1], distance: spatial[2]})
      conditions = { q: @term, facets: facets }
        .merge(filters)
        .merge(page: page, page_size: 100)
        .merge(fields: ['id', 'aggregatedCHO.spatial.coordinates', 'aggregatedCHO.type', 'aggregatedCHO.title', 'aggregatedCHO.creator', 'object.@id'])
      @data = DPLA::Items.by_conditions(conditions)
      @results = @data
    end

end