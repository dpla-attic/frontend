class Item
  class Result < Array
    attr_reader :count, :start, :limit

    def initialize response
      @count, @start, @limit = response[:count], response[:start], response[:limit]
      response[:docs].map { |doc| self.push Item.new(doc) }
    end

    def current_page
      start / limit + 1
    end

    def total_pages
      count / limit
    end

    alias limit_value limit
  end
end