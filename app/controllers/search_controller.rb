class SearchController < ApplicationController
  def list
    @search = DPLA::Search.new *search_params
    @documents = @search.documents args_params
    session[:last_query] = request.url
  end

  def timeline
  	@search = Search.build params.deep_merge(start: params[:year])
  end

  def timeline_year
  	@search = Search.build params.deep_merge(start: params[:year])
  end

  private

  def search_params
    term    = params[:q]
    filters = {}
    params.each do |key, value|
      case key
      when %w(start end before after)
        # TODO: move to API client ?
        filters[:created] ||= {}
        filters[:created][key] = date_from_params(value).to_s
      when %w(type language)
        filters[key] = value
      end
    end
    [term, filters]
  end

  def args_params
    args = {}
    params.each do |key, value|
      case key
      when %w(page page_size sort_by sort_order)
        args[key] = value
      end
    end
    args
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
