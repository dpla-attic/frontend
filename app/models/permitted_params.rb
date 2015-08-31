class PermittedParams < Struct.new(:params)
  YEARS = 1000..2100

  def search
    [term, filters]
  end

  def term
    params[:q] || ''
  end

  def filters(options = {})
    filters = params.map do |key, value|
      case key
      when *(%w(before after))
        if !options[:ignore_dates].present?
          date = date_from_params(value, end: key == 'before')
          [key, date] unless date.nil?
        end
      when *(%w(type spec_type language subject country state place provider partner))
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
      when 'sort_by'    then [key, value] if %w(title created).include?(value)
      when 'sort_order' then [key, value] if %w(asc desc).include?(value)
      end
    end
    args.compact.inject({}) { |h, e| h[e.first.to_sym] = e.last; h }
  end

  def date_from_params(date, options = {})
    if date.is_a? Hash and date[:year].present?
      year, month, day = *[date[:year], date[:month], date[:day]].map(&:to_i)

      unless YEARS.include? year
        year = options[:end] ? YEARS.last : YEARS.first
      end
      unless (1..12).include? month
        month = options[:end] ? 12 : 1
      end

      adate = Date.new(year, month)
      unless (adate.day..adate.end_of_month.day).include? day
        day = options[:end] ? adate.end_of_month.day : adate.day
      end

      Date.new(year, month, day) rescue nil
    end
  end

end

