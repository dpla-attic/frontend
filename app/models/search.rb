class Search < ActiveRecord::Base
  ACCEPTABLE_PARAMS  = [
    :q, :subject, :type, :start, :before, :after, :end, :language, :page, :page_size, :sort_by, :sort_order
  ]

  serialize :params, Hash
  attr_reader :results

  def self.build(params)
    params = {}.tap do |p|
      params.each do |key, value|
        p[key.to_sym] = value if ACCEPTABLE_PARAMS.include? key.to_sym
      end
    end
    self.new params: params
  end

  def for(mode)
    @fetch_mode = mode
    self
  end

  def fetch_mode
    @fetch_mode || :list
  end

  def refine
    {}.tap do |refine|
      refine[:subject] = Array(params[:subject])
      refine[:language] = Array(params[:language])
      refine[:type] = Array(params[:type])
      refine[:after] = date_from_params(params[:after])
      refine[:before] = date_from_params(params[:before])
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
        when :'created.start.year'
          facets[:start] = values
        else
          facets[key] = values.reject { |k,v| refine[key].include? k }
        end
      end
    end
  end

  # Get conditions from params in accordance with
  # current fetch mode
  def conditions(options = {})
    {}.tap do |c|
      params.each do |key, value|
        if [:start, :end, :before, :after].include? key
          c[:created] ||= {}
          c[:created][key] = date_from_params(value).to_s
        else
          c[key] = value
        end
      end

      case fetch_mode
      when :timeline
        c[:page_size] = 1
        c[:fields] = 'id'
        c[:facets] = 'created.start.year'
      else
        c[:facets] = ['subject.name', 'language.name', 'type']
      end
    end
  end

  # Common method for retrieving results.
  # Returns last fetched result if exists
  # or fetch if not fetched yet
  def results
    return @results if fetched_for? fetch_mode
    fetch conditions, fetch_mode
  end

  private

  def fetched_for?(mode)
    @last_fetched_mode.eql? mode
  end

  def fetched!(mode)
    @last_fetched_mode = mode
  end

  # Retrieve data from API by condition
  # Save current fetch mode(kind of conditions) if present
  def fetch(cond, mode = nil)
    fetched! mode if mode
    @results = Item.where cond
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