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
        conditions.map { |i| encode_uri(i) }.join('/')
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
          when 'subject'  then result['aggregatedCHO.subject.name']  = value
          when 'language' then result['aggregatedCHO.language.name'] = value
          when 'type'     then result['aggregatedCHO.type']          = value
          when 'location'
            next unless value.is_a?(Array)
            result['aggregatedCHO.spatial.coordinates'] = value[0..1].join(",")
          when 'distance'
            result['aggregatedCHO.spatial.distance'] = value.to_s + "km"
          when 'before'   then result['aggregatedCHO.date.before']   = value
          when 'after'    then result['aggregatedCHO.date.after']    = value
          when 'sort_by'
            case value.to_s
            when 'subject' then result[key] = 'aggregatedCHO.subject.name'
            when 'created' then result[key] = 'aggregatedCHO.date.begin'
            end
          when 'facets'
            result[key] = []
            value.each do |name|
              case name
              when 'subject'  then result[key] << 'aggregatedCHO.subject.name'
              when 'language' then result[key] << 'aggregatedCHO.language.name'
              when 'type'     then result[key] << 'aggregatedCHO.type'
              when 'spatial'  then result[key] << 'aggregatedCHO.spatial.name'  
              when 'date'     then result[key] << 'aggregatedCHO.date.begin.year'
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
          wrap = ['subject.name'].include?(key.to_s)
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