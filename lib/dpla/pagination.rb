module DPLA
  module Pagination
    attr_reader :count, :start, :limit

    alias limit_value limit

    def prepare(count, start, limit)
      @count, @start, @limit = count, start, limit
    end

    def current_page
      start / limit + 1
    end

    def total_pages
      count / limit
    end
  end
end