module DPLA
  class Result < Array
    attr_reader :count, :start, :limit, :facets

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
          value.each { |doc| push DPLA::Item.new(doc) }
        when 'facets'
          @facets = DPLA::Facets.new(value)
        end
      end if response.is_a? Hash
    end

    alias limit_value limit

    def prepare(count, start, limit)
      @count, @start, @limit = count, start, limit
    end

    def current_page
      start / limit + 1
    end

    def total_pages
      (count / limit.to_f).ceil
    end
  end
end