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
      if conditions.is_a? Array
        conditions.map { |i| encode_uri(i) }.join('/')
      elsif conditions.is_a? Hash
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
          if 'subject' == key.to_s
            result['subject.name'] = value
          else
            result[key] = value
          end
        end
      end
    end

    def transform_hash(conditions)
      [].tap do |query|
        conditions.each do |key, value|
          comma_separated = [:facets, :fields].include?(key.to_sym)
          no_wrap = [:sort_by, :sort_order, :page, :page_size, :title].include?(key.to_sym)
          value = Array(value).select { |v| v.present? }
          value.map! { |v| ['"', v, '"'].join } if !comma_separated and !no_wrap
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