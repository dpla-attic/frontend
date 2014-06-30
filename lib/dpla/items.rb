module DPLA
  class Items
    include HTTParty
    format :json
    base_uri Settings.api.url

    def self.by_ids(ids, conditions = {})
      ids_query = Conditions.new(ids)
      search_query = Conditions.new(conditions)
      load ("/items?id=#{ids_query}&#{api_key}&#{search_query}")
    end

    def self.by_conditions(conditions)
      query = Conditions.new(conditions)
      load "/items?#{query}&#{api_key}"
    end

    def self.load(query)
      response = self.get query, query_string_normalizer: -> s {s}
      Rails.logger.debug "API: Processing request #{response.request.uri}"
      if response.code != 200
        Rails.logger.info [
          "API: Error while processing request #{response.request.uri}",
          response.body
        ].join "\n"
      end
      Result.new(response.parsed_response)
    end

    def self.api_key
      "api_key=#{Settings.api.key}" if Settings.api.key
    end
  end
end