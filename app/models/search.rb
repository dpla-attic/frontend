class Search < ActiveRecord::Base
  ACCEPTABLE_PARAMS  = [
    :q, :subject, :type, :start, :end, :language, :page, :page_size, :sort_by, :sort_order
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
        when :'created.start.year'
          facets[:start] = values
        else
          facets[key] = values.reject { |k,v| refine[key].include? k }
        end
      end
    end
  end

  # Get conditions from params
  #
  def conditions_from_params(options = {})
    {}.tap do |result|
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

  # Common method for retrieving results.
  # Returns last fetched result if exists
  # or fetch result_list if not nothing fetched yet
  def results
    return @response if @response.present?
    results_list
  end

  # Results for normally search page
  def results_list
    return @response if fetched_for?(__method__)
    conditions = conditions_from_params.merge(
      facets: ['subject.name', 'language.name', 'type']
    )
    fetch conditions, __method__
  end

  # Results for timeline page
  def results_timeline
    return @response if fetched_for?(__method__)
    conditions = conditions_from_params.merge(
      page_size: 1,
      fields: 'id',
      facets: 'created.start.year'
    )
    fetch conditions, __method__
  end

  # Results for map page
  def results_spatial
    raise 'Not implemented yet'
  end

  private

  def fetch(cond, mode = nil)
    fetched! mode if mode
    @response = Item.where cond
  end

  def fetched_for?(mode)
    @last_fetched_mode.eql? mode
  end

  def fetched!(mode)
    @last_fetched_mode = mode
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