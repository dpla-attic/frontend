module DPLA
  class Search
    DEFAULT_FACETS = ['subject.name', 'language.name', 'type']

    attr_reader :term, :filters, :args, :facets

    # - term is search query
    # - filters is hash with refines
    #    {subject: 'Ships', type: ['image', 'text']}
    #
    def initialize(term, filters, options = {})
      @term    = term 
      @filters = filters.is_a?(Hash) ? filters : {}

      @args = options[:graph] ? { page_size: 0 } : {}
      if options[:facets].is_a?(Array)
        self.facets = options[:facets]
      end
      self
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

    # subject facets
    def subjects
      results.facets.subject
    end
    
    # languages facets
    def languages
      results.facets.language
    end
    
    # types facets
    def types
      results.facets.type
    end

    def years
      results.facets.year
    end

    def decades
      results.facets.decade
    end

    private

      def results
        @facets  = DEFAULT_FACETS + ['created.start.year', 'created.start.decade']
        conditions = { q: @term, facets: @facets }.merge(@filters).merge(@args)
        @result || @result = Items.by_conditions(conditions)
      end

  end
end
