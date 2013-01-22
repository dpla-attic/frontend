module DPLA
  class Item
    include HTTParty
    format :json
    base_uri Settings.api.url

    VALID_CONDITIONS = {
      simple: [
        :q, :title, :description, :subject, :dplaContributor, :creator, :type,
        :publisher, :format, :rights, :contributor, :isPartOf, :page, :page_size],
      spatial:    [:city, :state, :coordinates, :'iso3166-2'],
      temporal:   [:before, :after],
      facets:     [:'subject.name', :format],
      sort_by:    [:created],
      sort_order: [:asc, :desc]
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
      {}.tap do |result|
        conditions.each do |key, value|
          if VALID_CONDITIONS[:simple].include? key.to_sym
            result[key] = value
          elsif [:spatial, :temporal].include? key.to_sym and value.is_a? Hash
            parent = key.to_sym
            value
              .select { |k, v| VALID_CONDITIONS[parent].include? k }
              .each   { |k, v| result[:"#{parent}.#{k}"] = v }
          elsif [:sort_by, :sort_order].include? key.to_sym
            result[key.to_sym] = value if VALID_CONDITIONS[key.to_sym].include? value.to_sym
          elsif key.to_sym == :facets and value.is_a? Array
            facets = value.select { |v| VALID_CONDITIONS[:facets].include? v }
            result[:facets] = facets.join(',') if facets.present?
          end
        end
      end
    end
  end
end