module DPLA
  class Item
    # attr_accesstors here

    # - id is DPLA API Item UUID
    def self.by_id(id)
      # DPLA::Item
    end

    # - options is hash with conditions
    #     {q: 'civil war', subject: 'Ships', page: 3, facets}
    def self.by_conditions(options = {})
      # DPLA::Result
    end

    private

    # URI encode and prepare query string by internal conditions
    # - when String - just URI encode
    # - when Array - encode elements and join by slash(/)
    # - when Hash - build query string regarding special rules
    def self.prepare_conditions(conditions = {})
      encode_uri = ->(v) {URI.encode(v.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}
      prepare_value = ->(*args) {
        value = args.pop
        key = args.join('.')
      }

      if [Array, String].include? conditions.class
        return Array(conditions).map { |v| encode_uri.call v }.join '/'
      else
        [].tap do |result|
          conditions.each do |key, value|
            if [Numeric, String].include? value.class
              result << "#{key}=#{encode_uri.call(value)}"
            end
          end
        end.join '&'
      end
    end
  end
end