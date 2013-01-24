module DPLA
  class Item
    include HTTParty
    format :json
    base_uri Settings.api.url

    def find(ids)
      ids = ids.join ',' if ids.is_a? Array
      response = self.class.get('/items/' + ids.to_s)
      parsed = response.parsed_response
      Rails.logger.debug "API: Processing request #{response.request.uri}"
      [].tap do |a|
        if parsed.is_a? Hash and parsed['docs'].is_a? Array
          parsed['docs'].each do |doc|
            a.push doc unless doc['error'].present?
          end
        end
      end
    end

    def where(conditions)
      response = self.class.get('/items', query: prepare_conditions(conditions), query_string_normalizer: -> s {s})
      { count: 0, start: 0, limit: 10, docs: [], facets: [] }.tap do |result|
        if response.code == 200
          parsed = response.parsed_response
          Rails.logger.debug "API: Processing request #{response.request.uri}"
          [:count, :start, :limit, :docs, :facets].each { |key| result[key] = parsed[key.to_s] if parsed[key.to_s].present? }
        else
          Rails.logger.info [
            "API: Error while processing request #{response.request.uri}",
            response.body
          ].join "\n"
        end
      end
    end

    def prepare_conditions(conditions)
      uri_encode = -> uri {URI.encode(uri.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}
      query = [].tap do |query|
        conditions.each do |key, value|
          if value.is_a? Hash
            value.each { |subkey,value| query << "#{key}.#{subkey}=#{uri_encode.call(value)}" }
          else
            separator = :facets == key.to_sym ? ',' : '+AND+'
            value = Array(value).map { |v| uri_encode.call(v) }.join(separator)
            query << "#{key}=#{value}"
          end
        end
      end
      query.join '&'
    end
  end
end