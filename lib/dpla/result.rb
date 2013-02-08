module DPLA
  class Result

    # - response is raw JSON from API
    def initialize(response)
    end

    def docs
      # Array of DPLA::Item
    end

    def facets
      # Hash
    end

    def count; end

    def limit; end

    def start; end
  end
end