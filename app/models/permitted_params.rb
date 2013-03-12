class PermittedParams < Struct.new(:params)

  def search
    [term, filters]
  end

  def term
    params[:q] || ''
  end

  def filters
    filters = params.map do |key, value|
      case key
      when *(%w(before after))
        date = date_from_params(value)
        [key, date] unless date.nil?
      when *(%w(type language subject location))
        [key, value]
      end
    end
    filters.compact.inject({}) { |h, e| h[e.first.to_sym] = e.last; h }
  end

  def args
    args = params.map do |key, value|
      case key
      when 'page'       then [key, value]
      when 'page_size'  then [key, value] if %w(10 20 50 100).include?(value)
      when 'sort_by'    then [key, value] if %w(subject created).include?(value)
      when 'sort_order' then [key, value] if %w(asc desc).include?(value)
      end
    end
    args.compact.inject({}) { |h, e| h[e.first.to_sym] = e.last; h }
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