class Item
  class Search < ActiveRecord::Base
    ACCEPLABLE_PARAMS  = [:q, :subject, :type, :after, :before, :language, :page, :page_size, :sort_by, :sort_order].freeze
    DEFAULT_CONDITIONS = {facets: %w(subject.name language.name type)}.freeze

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
        refine[:subject] = Array(params[:subject])
        refine[:language] = Array(params[:language])
        refine[:type] = Array(params[:type])
        refine[:after] = get_valid_date(params[:after])
        refine[:before] = get_valid_date(params[:before])
      end
    end

    def facets
      {}.tap do |facets|
        results.facets.each do |key, values|
          case key
          when :'subject.name'
            facets[:subject] = values.reject { |k,v| refine[:subject].include? k }
          when :'language.name'
            facets[:language] = values.reject { |k,v| refine[:language].include? k }
          else
            facets[key] = values.reject { |k,v| refine[key].include? k }
          end
        end
      end
    end

    def conditions
      DEFAULT_CONDITIONS.dup.tap do |result|
        params.each do |key, value|
          if [:after, :before].include? key
            result[:created] ||= {}
            result[:created][key] = get_valid_date(value)
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

    def get_valid_date(date, options = {})
      if date.present? && date[:year].present?
        month = date[:month].present? ? date[:month] : (options[:before] ? '12' : '1')
        day   = date[:day].present?   ? date[:day]   : (options[:before] ? '31' : '1')
        "#{date[:year]}-#{month}-#{day}"
      end
    end
  end
end