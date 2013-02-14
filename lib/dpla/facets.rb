module DPLA
  class Facets
    attr_reader :subject, :language, :type, :year, :decade

    def initialize(facets)
      facets.each do |key, value|
        if 'subject.name' == key and value['terms'].is_a? Array
          @subject = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end
        elsif 'language.name' == key and value['terms'].is_a? Array
          @language = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end
        elsif 'type' == key and value['terms'].is_a? Array
          @type = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end
        elsif 'created.start.year' == key and value['entries'].is_a? Array
          @year = {}.tap do |subject|
            value['entries'].each { |entry| subject[entry['time']] = entry['count'] }
          end
        elsif 'created.start.decade' == key and value['entries'].is_a? Array
          @decade = {}.tap do |subject|
            value['entries'].each { |entry| subject[entry['time']] = entry['count'] }
          end
        end
      end if facets.is_a? Hash
    end
  end
end