class Item
  class Result < Array
    attr_reader :count, :start, :limit, :facets

    alias limit_value limit

    def initialize response
      @count, @start, @limit = response[:count], response[:start], response[:limit]
      response[:docs].map { |doc| self.push Item.new(doc) }
      @facets = {}
      response[:facets].map do |key, value|
        @facets[key.to_sym] ||= {}
        case value['_type']
        when 'terms'
          value['terms'].each { |term| @facets[key.to_sym][term['term']] = term['count'] }
        when 'date_histogram'
          value['entries'].each { |entry| @facets[key.to_sym][entry['time']] = entry['count'] }
        end
      end
    end

    def current_page
      start / limit + 1
    end

    def total_pages
      count / limit
    end

    def facets
      @facets
    end
  end
end