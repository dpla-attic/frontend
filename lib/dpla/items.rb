module DPLA
  class Items
    include HTTParty
    format :json
    base_uri Settings.api.url

    def initialize(ids); end

    def documents
      raise 'Not implemented yet'
    end
  end
end