module DPLA
  class Search
    @args, @filters = nil

    attr_writer :args

    # Kaminari expected methods

    # - term is search query
    # - filters is hash with refines
    #    {subject: 'Ships', type: ['image', 'text']}
    def initialize(term, filters = {})
    end

    def result
      
    end

    # - args is search result manipulation conditions
    #    {sort_by: :created, sort_order: :desc, page: 2, page_size: 10}
    def items(args = {})
      conditions = @args.merge args
      # Array of DPLA::Items
    end
    
    # name is field e.g. :subject, :type, :lang, :before, :after, etc.
    def filters(name)
      # Array|Data|nil
    end

    # subject facets
    def subjects
      # Hash {'Ships' => 512}
    end
    
    # languages facets
    def languages
      # Hash {'English' => 512}
    end
    
    # types facets
    def types
      # Hash {'image' => 512}
    end    
  end
end