module DPLA
  class Item
    include HTTParty
    format :json
    base_uri Settings.api.url

    def find(ids)
      ids = Array(ids).map { |v| encode_uri(v) }.join(',')
      response = self.class.get('/items/' + ids)
      Rails.logger.debug "API: Processing request #{response.request.uri}"
      parsed = response.parsed_response
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
          Rails.logger.debug "API: Processing request #{response.request.uri}"
          parsed = response.parsed_response
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
      query = [].tap do |query|
        conditions.each do |key, value|
          if value.is_a? Hash
            value.each { |subkey,value| query << "#{key}.#{subkey}=#{encode_uri(value)}" }
          else
            separator = :facets == key.to_sym ? ',' : '+AND+'
            value = Array(value).map { |v| encode_uri(v) }.join(separator)
            query << "#{key}=#{value}"
          end
        end
      end
      query.join '&'
    end

    def encode_uri(value)
       URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end
end