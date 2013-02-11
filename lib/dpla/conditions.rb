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
          when 'subject'
            result['subject.name'] = value
          when 'before'
            result['created.before'] = value
          when 'after'
            result['created.after'] = value
          when 'sort_by'
            case value.to_s
            when 'subject'
              result[key] = 'subject.name'
            when 'created'
              result[key] = 'created.start'
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