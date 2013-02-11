module DPLA
  class Search
    DEFAULT_FACETS = ['subject.name', 'language.name', 'type']

    attr_reader :term, :filters, :args, :facets

    # - term is search query
    # - filters is hash with refines
    #    {subject: 'Ships', type: ['image', 'text']}
    def initialize(term, filters = {})
      @term    = term 
      @filters = {}.tap { |result| filters.each { |k,v| result[k.to_sym] = Array(v) } }
      @facets  = DEFAULT_FACETS
      @args    = {}
    end

    def result(args = {})
      conditions = { facets: @facets }.merge(@filters).merge(@args)
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
      # Hash {'English' => 512}
    end
    
    # types facets
    def types
      # Hash {'image' => 512}
    end

    def args=(args)
      @args = args
      @result = nil
    end

    def facets=(facets)
      @facets = facets
      @result = nil
    end
  end
end