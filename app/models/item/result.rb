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
        value['terms'].each do |term|
          @facets[key.to_sym][term['term']] = term['count']
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