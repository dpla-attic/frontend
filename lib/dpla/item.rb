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
  end
end