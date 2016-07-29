module DPLA
  class Result < Array
    attr_reader :start, :limit, :facets

    # - response is raw JSON from API
    def initialize(response)
      response.each do |key, value|
        case key
        when 'count'
          @count = value.to_i rescue 0
        when 'start'
          @start = value.to_i rescue 0
        when 'limit'
          @limit = value.to_i rescue 0
        when 'docs'
          value.each { |doc| push Item.new(doc) }
        when 'facets'
          @facets = DPLA::Facets.new(value)
        end
      end if response.is_a? Hash
    end

    alias limit_value limit

    # total number of search results
    # this overrides the normal count method for an Array
    def count
      @count || 0
    end

    def prepare(count, start, limit)
      @count, @start, @limit = count, start, limit
    end

    def current_page
      start / limit + 1
    end

    def total_pages
      (count / limit.to_f).ceil
    end

    def last_page?
      current_page >= total_pages
    end

    ##
    # Get the position of the next item in the DPLA::Result, given the current
    # item's position.
    # Returns nil if there is no next result.
    # Positions are zero-based, so the first position in a result is 0.
    #
    # @param Integer
    # @return Integer || nil
    def position_after(index)
      current_position = start.to_i + index
      return (current_position + 1) if count > (current_position + 1)
      return nil
    end

    ##
    # Get the position of the previous item in the DPLA::Result, given the
    # current item's position.
    # Returns nil if there is no previous result.
    # Positions are zero-based, so the first position in a result is 0.
    #
    # @param Integer
    # @return Integer || nil
    def position_before(index)
      current_position = start.to_i + index
      return (current_position - 1) if current_position > 0
      return nil
    end
  end
end
