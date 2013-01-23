class Item
  class Search < ActiveRecord::Base
    ACCEPTABLE_PARAMS = [
      :q, :subject, :page, :page_size, :sort_by, :sort_order]
    FIELD_ALIASES     = {:'subject.name' => :subject}

    serialize :params, Hash

    def self.build(params)
      params = {}.tap do |p|
        params.each do |key, value|
          p[key.to_sym] = value if ACCEPTABLE_PARAMS.include? key.to_sym
        end
      end
      self.new params: params
    end

    def results
      @results ||= fetch
    end

    def refine
      {}.tap do |refine|
        if params[:subject]
          refine[:subject] = params[:subject].is_a?(Array) ? params[:subject] : [params[:subject]]
        end
      end
    end

    def facets
      {}.tap do |facets|
        results.facets.each do |key, values|
          refine_key = FIELD_ALIASES.has_key?(key) ? FIELD_ALIASES[key] : key
          refines = params[refine_key] || []
          facets[refine_key] = values.reject { |k,v| refines.include? k }
        end
      end
    end

    def conditions
      defaults = {subject: [], facets: %w(subject.name format)}
      defaults.tap do |result|
        params.each do |key, value|
          case key
          when :subject
            result[:subject] = value.is_a?(Array) ? value.join('+AND+') : value
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