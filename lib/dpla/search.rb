module DPLA
  class Search
    DEFAULT_FACETS = ['subject.name', 'language.name', 'type']

    attr_reader :term, :filters, :args, :facets_list

    include HTTParty
    format :json
    base_uri Settings.api.url

    # ex: term = 'civil war', filters = {}
    def initialize(term, filters=nil, options={})
      @term    = term
      @filters = filters || {}
      @args    = {}
      @facets_list  = DEFAULT_FACETS
    end

    # Options contains info about sort, page
    # {sort_by: 'created.start', sort_order: 'desc', page: 1, page_size: 20}
    def documents(options={})
      valid_keys = [:sort_by, :sort_order, :page, :page_size]
      opts = options.slice(*valid_keys)
      if opts == args
        return @documents if @documents
        if @data.nil? or @data[:docs].empty?
          @args = opts
          @data = get_items # with docs
        end
      else
        @args = opts
        @data = get_items #with docs
      end

      @documents = @data[:docs].map { |doc| Document.new(doc) }
      @documents.extend Pagination
      @documents.prepare(@data[:count], @data[:start], @data[:limit])
      @documents
    end

    def subjects
      _name = 'subject.name'
      return @subjects if @subjects
      if @data.nil? or @data[:facets][_name].nil?
        @facets_list << _name
        @data = get_items
      end
      @subjects = {}
      @data[:facets][_name]['terms'].each do |term| 
        @subjects[term['term']] = term['count']
      end
      @subjects
    end

    def languages
      _name = 'language.name'
      return @languages if @languages
      if @data.nil? or @data[:facets][_name].nil?
        @facets_list << _name
        @data = get_items # with languages
      end
      @languages = {}
      @data[:facets][_name]['terms'].each do |term| 
        @languages[term['term']] = term['count']
      end
      @languages
    end

    def types
      _name = 'type'
      return @types if @types
      if @data.nil? or @data[:facets][_name].nil?
        @facets_list << _name
        @data = get_items # with types
      end
      @types = {}
      @data[:facets][_name]['terms'].each do |term| 
        @types[term['term']] = term['count']
      end
      @types   
    end

    def dates
    end

    def refine
      {}.tap do |refine|
        refine[:subject]  = Array filters[:subject]
        refine[:language] = Array filters[:language]
        refine[:type]     = Array filters[:type]
        refine[:after]    = filters[:after]
        refine[:before]   = filters[:before]
      end
    end

    private

    def get_items
      response = self.class.get('/items', query: prepare_query, query_string_normalizer: -> s {s})
      { count: 0, start: 0, limit: 10, docs: [], facets: [] }.tap do |result|
        if response.code == 200
          Rails.logger.debug "API: Processing request #{response.request.uri}"
          parsed = response.parsed_response
          [:count, :start, :limit, :docs, :facets].each { |key| result[key] = parsed[key.to_s] if parsed[key.to_s].present? }
        else
          Rails.logger.info [
            "API: Error while processing request #{response.request.uri}",
            response.body
          ].join "\n"
        end
      end
    end

    def conditions
      {q: term}.merge(filters).merge(args).merge(facets: facets_list)
    end

    def prepare_query
      query = [].tap do |query|
        conditions.each do |key, value|
          if value.is_a? Hash
            value
              .select { |subkey,value| value.present? }
              .each { |subkey,value| query << "#{key}.#{subkey}=#{encode_uri(value)}" }
          elsif value.present?
            comma_separated = [:facets, :fields].include?(key.to_sym)
            no_wrap = [:sort_by, :sort_order, :page, :page_size, :title].include?(key.to_sym)
            value = Array(value).reject { |v| v.empty? }
            value.map! { |v| ['"', v, '"'].join } if !comma_separated and !no_wrap
            value.map! { |v| encode_uri(v) }
            value = value.join(comma_separated ? ',' : '+AND+')
            query << "#{key}=#{value}"
          end
        end
      end
      query.join '&'
    end

    def encode_uri(value)
       URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end
end