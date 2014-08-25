module DPLA
  class Facets
    attr_reader :subject, :language, :type, :provider, :partner, :year, :country, :state, :place

    def initialize(facets)
      facets.each do |key, value|
        case key
        when 'sourceResource.subject.name'
          @subject = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'sourceResource.language.name'
          @language = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'sourceResource.type'
          @type = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'admin.contributingInstitution'
          @provider = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'provider.name'
          @partner = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'sourceResource.spatial.country'
          @country = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'sourceResource.spatial.state'
          @state = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'sourceResource.spatial.name'
          @place = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'sourceResource.date.begin.year'
          @year = {}.tap do |subject|
            value['entries'].each { |entry| subject[entry['time']] = entry['count'] }
          end if value['entries'].is_a? Array
        end
      end if facets.is_a? Hash
    end
  end
end