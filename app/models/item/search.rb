class Item
  class Search < ActiveRecord::Base
    ACCEPTABLE_PARAMS  = [
      :q, :subject, :type, :start, :end, :language, :page, :page_size, :sort_by, :sort_order
    ]
    DEFAULT_CONDITIONS = {
      facets: %w(subject.name language.name type)
    }

    serialize :params, Hash

    def self.build(params)
      params = {}.tap do |p|
        params.each do |key, value|
          p[key.to_sym] = value if ACCEPTABLE_PARAMS.include? key.to_sym
        end
      end
      self.new params: params
    end

    def refine
      {}.tap do |refine|
        refine[:subject] = Array(params[:subject])
        refine[:language] = Array(params[:language])
        refine[:type] = Array(params[:type])
        refine[:start] = date_from_params(params[:start])
        refine[:end] = date_from_params(params[:end])
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
      {}.merge(DEFAULT_CONDITIONS).tap do |result|
        params.each do |key, value|
          if [:start, :end].include? key
            result[:created] ||= {}
            result[:created][key] = date_from_params(value).to_s
          else
            result[key] = value
          end
        end
      end
    end

    # Results for normally search page
    def results
      @results ||= fetch
    end

    # Results for timeline page
    def timeline
      @results ||= fetch(conditions)
    end

    # Results for map page
    def spatial
      raise 'Not implemented yet'
    end

    private

    def fetch
      @results = Item.where(conditions)
    end

    def date_from_params(date, options = {})
      if date.is_a? Hash and date[:year].present?
        month = date[:month].present? ? date[:month] : (options[:start] ? '12' : '1')
        day   = date[:day].present?   ? date[:day]   : (options[:start] ? '31' : '1')
        Date.new *[date[:year], month, day].map(&:to_i) rescue nil
      elsif date.is_a?(String) and date.present?
        Date.new *date.split('-').map(&:to_i) rescue nil
      end
    end
  end
end