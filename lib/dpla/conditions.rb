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
      # When is `conditions' not an array or hash?  It seems that it should
      # always be one or the other, based on what I see elsewhere in the
      # code. It can be an array of IDs when called by DPLA::Items.by_ids.
      # It is usually a Hash.  The default case would ideally raise an
      # exception or assert that `conditions' has a `#to_s' method for
      # `encode_uri'.  --Mark B
      #
      case conditions
      when Array
        encode_uri(conditions.map { |i| i }.join(' OR '))
      when Hash
        conditions = convert_conditions(conditions)
        transform_hash(conditions)
      else
        # This appears to be unreachable, but `conditions' has to have a
        # `#to_s' method or `#encode_uri' will raise an exception.
        encode_uri(conditions)
      end
    end

    # Convert conditions aliases
    # For demo purposes, no partner condition as we are only pulling from
    # Digital Commonwealth.
    def convert_conditions(conditions)
      {}.tap do |result|
        conditions.each do |key, value|
          case key.to_s
          when 'subject'  then result['sourceResource.subject.name'] = value
          when 'language' then result['sourceResource.language.name'] = value
          when 'type'     then result['sourceResource.type'] = value
          when 'spec_type' then result['sourceResource.specType'] = value
          when 'provider' then result['admin.contributingInstitution'] = value
          when 'country'  then result['sourceResource.spatial.country'] = value
          when 'state'    then result['sourceResource.spatial.state'] = value
          when 'place'    then result['sourceResource.spatial.name'] = value
          when 'distance' then result['sourceResource.spatial.distance'] = value.to_s + "km"
          when 'before'   then result['sourceResource.date.before'] = value
          when 'after'    then result['sourceResource.date.after'] = value
          when 'sort_by'
            case value.to_s
            when 'title' then result[key] = 'sourceResource.title'
            when 'created' then result[key] = 'sourceResource.date.begin'
            end
          when 'facets'
            result[key] = []
            value.each do |name|
              case name
              when 'subject'  then result[key] << 'sourceResource.subject.name'
              when 'language' then result[key] << 'sourceResource.language.name'
              when 'type'     then result[key] << 'sourceResource.type'
              when 'spec_type' then result[key] << 'sourceResource.specType'
              when 'provider' then result[key] << 'admin.contributingInstitution'
              when 'partner'  then result[key] << 'provider.name'
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
      # For demo purposes, limit provider to Digital Commonwealth and object to
      # IIIF images served rom ark.digitalcommonwealth.org
      dc_params = ["provider.name=Digital%20Commonwealth",
                   "object=*ark.digitalcommonwealth.org*",
                   "sourceResource.type=image+OR+text"]
      dc_params.tap do |query|
        conditions.each do |key, value|
          next unless value.present?
          comma_separated = [:facets, :fields].include?(key.to_sym)
          wrap = /subject|language|type|spec_type|dataProvider|provider\.name|country|state|spatial\.name/i.match key.to_s
          value = Array(value).select { |v| v.present? }
          value.map! { |v| ['"', v, '"'].join } if !comma_separated and wrap
          value.map! { |v| encode_uri(v) }
          value = value.join(comma_separated ? ',' : '+AND+')
          query << "#{key}=#{value}"
        end
      end.join '&'
    end

    def encode_uri(value)
       # It is not clear why characters matching URI::PATTERN::UNRESERVED are
       # declared unsafe below, but one might assume it's because those
       # characters could be used to subvert an Elasticsearch search.
       URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end
end