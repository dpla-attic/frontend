module DPLA
  class Search
    DEFAULT_FACETS = ['subject.name', 'language.name', 'type']

    attr_reader :term, :filters, :facets

    # - term is search query
    # - filters is hash with refines
    #    {subject: 'Ships', type: ['image', 'text']}
    def initialize(term, filters = {})
      @term    = term 
      @filters = filters
      @facets  = DEFAULT_FACETS + ['created.start.year', 'created.start.decade']
      @args    = {}
      self
    end

    def result(args = {})
      conditions = { q: @term, facets: @facets }.merge(@filters).merge(args)
      @result || @result = Items.by_conditions(conditions)
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
      result.facets.subject
    end
    
    # languages facets
    def languages
      result.facets.language
    end
    
    # types facets
    def types
      result.facets.type
    end

    def years
      result.facets.created_year
    end

    def decades
      result.facets.created_decade
    end
  end
end
