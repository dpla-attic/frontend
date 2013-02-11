module DPLA
  class Facets
    attr_reader :subject

    def initialize(facets)
      facets.each do |key, value|
        if 'subject.name' == key and value['terms'].is_a? Array
          @subject = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end
        elsif 'language.name' == key and value['terms'].is_a? Array
          @subject = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end
        elsif 'type' == key and value['terms'].is_a? Array
          @subject = {}.tap do |subject|
            value['terms'].each { |term| subject[term['term']] = term['count'] }
          end
        end
      end if facets.is_a? Hash
    end
  end
end