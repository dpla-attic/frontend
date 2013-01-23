module DPLA
  class Item
    include HTTParty
    format :json
    base_uri Settings.api.url

    def find(ids)
      ids = ids.join ',' if ids.is_a? Array
      response = self.class.get('/items/' + ids.to_s).parsed_response
      [].tap do |a|
        if response.is_a? Hash and response['docs'].is_a? Array
          response['docs'].each do |doc|
            a.push doc unless doc['error'].present?
          end
        end
      end
    end

    def where(conditions)
      response = self.class.get('/items', query: prepare_conditions(conditions))
      { count: 0, start: 0, limit: 10, docs: [], facets: [] }.tap do |result|
        if response.code == 200
          parsed = response.parsed_response
          [:count, :start, :limit, :docs, :facets].each { |key| result[key] = parsed[key.to_s] if parsed[key.to_s].present? }
        else
          Rails.logger.info [
            "Error while processing API request #{response.request.uri}",
            response.body
          ].join "\n"
        end
      end
    end

    def prepare_conditions(conditions)
      {}.tap do |result|
        conditions.each do |key, value|
          if value.is_a? Hash
            value.each { |subkey,value| result["#{key}.#{subkey}".to_sym] = value }
          elsif value.is_a? Array
            result[key] = value.join ','
          elsif value.is_a? Numeric or value.is_a? String
            result[key] = value
          end
        end
      end
    end
  end
end