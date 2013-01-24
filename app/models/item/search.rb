class Item
  class Search < ActiveRecord::Base
    ACCEPLABLE_PARAMS  = [:q, :subject, :mime, :page, :page_size, :sort_by, :sort_order].freeze
    DEFAULT_CONDITIONS = {facets: %w(subject.name format)}.freeze

    serialize :params, Hash

    def self.build(params)
      params = {}.tap do |p|
        params.each do |key, value|
          p[key.to_sym] = value if ACCEPLABLE_PARAMS.include? key.to_sym
        end
      end
      self.new params: params
    end

    def results
      @results ||= fetch
    end

    def refine
      {}.tap do |refine|
        refine[:subject] = Array(params[:subject]) if params[:subject]
        refine[:format] = Array(params[:mime]) if params[:mime]
      end
    end

    def facets
      {}.tap do |facets|
        results.facets.each do |key, values|
          case key
          when :'subject.name'
            refines = params[:subject] || []
            facets[:subject] = values.reject { |k,v| refines.include? k }
          when :format
            refines = params[:mime] || []
            facets[:format] = values.reject { |k,v| refines.include? k }
          else
            refines = params[key] || []
            facets[key] = values.reject { |k,v| refines.include? k }
          end
        end
      end
    end

    def conditions
      DEFAULT_CONDITIONS.dup.tap do |result|
        params.each do |key, value|
          if :mime == key
            result[:format] = value
          else
            result[key] = value
          end
        end
      end
    end

    private

    def fetch
      @results = Item.where(conditions)
    end
  end
end