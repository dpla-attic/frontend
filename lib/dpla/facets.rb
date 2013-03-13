module DPLA
  class Facets
    attr_reader :subject, :language, :type, :year, :location, :state

    def initialize(facets)
      facets.each do |key, value|
        case key
        when 'aggregatedCHO.subject.name'
          @subject = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'aggregatedCHO.language.name'
          @language = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'aggregatedCHO.type'
          @type = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'aggregatedCHO.spatial.name'
          @location = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'aggregatedCHO.spatial.state'
          @state = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end if value['terms'].is_a? Array
        when 'aggregatedCHO.date.begin.year'
          @year = {}.tap do |subject|
            value['entries'].each { |entry| subject[entry['time']] = entry['count'] }
          end if value['entries'].is_a? Array
        end
      end if facets.is_a? Hash
    end
  end
end