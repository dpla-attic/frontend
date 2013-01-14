module DPLA
  class Item
    include HTTParty
    base_uri 'content1.qa.dp.la/api/v1'
    format :json

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
      response = self.class.get('/items', query: conditions)
      { count: 0, start: 0, limit: 10, docs: [], facets: [] }.tap do |result|
        if response.code == 200
          parsed = response.parsed_response
          [:count, :start, :limit, :docs, :facets].each { |key| result[key] = parsed[key.to_s] if parsed[key.to_s].present? }
        end
      end
    end
  end
end