module DPLA
  class Conditions
    def initialize(conditions)
      @query = transform conditions
    end

    def to_s
      @query
    end

    private

    def transform(conditions)
      case conditions
      when Array
        conditions.map { |i| encode_uri(i) }.join(',')
      when Hash
        conditions = convert_conditions(conditions)
        transform_hash(conditions)
      else
        encode_uri(conditions)
      end
    end

    # Convert conditions aliases
    def convert_conditions(conditions)
      {}.tap do |result|
        conditions.each do |key, value|
          case key.to_s
          when 'subject'  then result['sourceResource.subject.name'] = value
          when 'language' then result['sourceResource.language.name'] = value
          when 'type'     then result['sourceResource.type'] = value
          when 'provider' then result['dataProvider'] = value
          when 'country'  then result['sourceResource.spatial.country'] = value
          when 'state'    then result['sourceResource.spatial.state'] = value
          when 'place'    then result['sourceResource.spatial.name'] = value
          when 'distance' then result['sourceResource.spatial.distance'] = value.to_s + "km"
          when 'before'   then result['sourceResource.date.before'] = value
          when 'after'    then result['sourceResource.date.after'] = value
          when 'sort_by'
            case value.to_s
            when 'subject' then result[key] = 'sourceResource.subject.name'
            when 'created' then result[key] = 'sourceResource.date.begin'
            end
          when 'facets'
            result[key] = []
            value.each do |name|
              case name
              when 'subject'  then result[key] << 'sourceResource.subject.name'
              when 'language' then result[key] << 'sourceResource.language.name'
              when 'type'     then result[key] << 'sourceResource.type'
              when 'provider' then result[key] << 'dataProvider'
              when 'date'     then result[key] << 'sourceResource.date.begin.year'
              when 'country'  then result[key] << 'sourceResource.spatial.country'
              when 'state'    then result[key] << 'sourceResource.spatial.state'
              when 'place'    then result[key] << 'sourceResource.spatial.name'
              end
            end
          else
            result[key] = value if value.present?
          end
        end
      end
    end

    def transform_hash(conditions)
      [].tap do |query|
        conditions.each do |key, value|
          next unless value.present?
          comma_separated = [:facets, :fields].include?(key.to_sym)
          wrap = /subject|language|type|dataProvider|country|state|spatial\.name/i.match key.to_s
          value = Array(value).select { |v| v.present? }
          value.map! { |v| ['"', v, '"'].join } if !comma_separated and wrap
          value.map! { |v| encode_uri(v) }
          value = value.join(comma_separated ? ',' : '+AND+')
          query << "#{key}=#{value}"
        end
      end.join '&'
    end

    def encode_uri(value)
       URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end
end