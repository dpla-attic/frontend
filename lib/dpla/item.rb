module DPLA
  class Item
    include HTTParty
    format :json
    base_uri Settings.api.url

    VALID_API_PARAMS = {
      q:               true,
      title:           true,
      description:     true,
      subject:         true,
      dplaContributor: true,
      creator:         true,
      type:            true,
      publisher:       true,
      format:          true,
      rights:          true,
      contributor:     true,
      isPartOf:        true,
      spatial: {
        city:           true,
        state:          true,
        coordinates:    true,
        :'iso3166-2' => true
      },
      temporal: {
        before: true,
        after:  true
      },
      facets: {
      },
      page:            true,
      page_size:       true,
      sort_by:         true,
      sort_order:      true,
    }

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

    private

    def prepare_conditions(conditions)
      reject_disallowed = -> hash,allowed {
        hash.reject { |k| !(allowed.has_key?(k) || allowed.has_key?(k.to_sym)) }
      }
      {}.tap do |result|
        reject_disallowed.call(conditions, VALID_API_PARAMS).each do |key, value|
          if value.is_a? Hash
            reject_disallowed.call(value, VALID_API_PARAMS[key.to_sym]).each do |subkey, value|
              result["#{key}.#{subkey}".to_sym] = value
            end
          else
            result[key] = value
          end
        end
      end
    end
  end
end