class Item
  class Search < ActiveRecord::Base
    ACCEPTABLE_PARAMS  = [:q, :page, :page_size, :sort_by, :sort_order, :refine]
    DEFAULT_CONDITIONS = {q: [], facets: %w(subject.name)}
    FIELD_ALIASES     = {:'subject.name' => :subject}

    serialize :params, Hash

    def self.build(params)
      params = params.select { |key, value| ACCEPTABLE_PARAMS.include? key }
      self.new params: params
    end

    def results
      @results ||= fetch
    end

    def refine
      params[:refine] || {}
    end

    def facets
      {}.tap do |facets|
        results.facets.each do |key, values|
          if FIELD_ALIASES.has_key? key
            refine_key = FIELD_ALIASES[key]
            refines = (params[:refine] and params[:refine][refine_key]) || []
            facets[:subject] = values.reject { |k,v| refines.include? k }
          end
        end
      end
    end

    def conditions
      DEFAULT_CONDITIONS.dup.tap do |result|
        params.each do |key, value|
          case key
          when :q
            result[:q].push value
          when :sort_by
          when :sort_order
          when :refine
            if value.is_a? Hash
              value.each do |key, value|
                value = value.is_a?(Array) ? value : [value]
                case key.to_sym
                when :subject
                  value.to_a.each { |refine| result[:q].push value }
                end
              end
            end
          else
            result[key] = value
          end
        end
        result[:q] = result[:q].join '+AND+'
      end
    end

    private

    def fetch
      @results = Item.where(conditions)
    end
  end
end