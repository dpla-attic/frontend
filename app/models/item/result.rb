class Item
  class Result < Array
    attr_reader :count, :start, :limit

    def initialize response
      @count, @start, @limit = response[:count], response[:start], response[:limit]
      response[:docs].map { |doc| self.push Item.new(doc) }
    end
  end
end