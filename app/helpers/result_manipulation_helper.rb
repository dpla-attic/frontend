module ResultManipulationHelper
  def page_size_options
    options = [].tap do |result|
      [10, 20, 50, 100].tap do |counts|
        page_size = params[:page_size].to_i
        if page_size > 0 and ! counts.include? page_size
          counts.push page_size
          counts.sort!
        end
      end.each do |size|
        result.push [
          size,
          url_for(params.merge(page_size: size, page: nil)),
          size.to_s == params[:page_size] ? {selected: :selected} : {}
        ]
      end
    end
    options_for_select options
  end

  def sort_by_options
    options = [].tap do |result|
      {
        relevance: { sort_by: nil, sort_order: nil },
        a2z:       { sort_by: 'subject', sort_order: 'asc' },
        z2a:       { sort_by: 'subject', sort_order: 'desc' },
        old2new:   { sort_by: 'created', sort_order: 'asc' },
        new2old:   { sort_by: 'created', sort_order: 'desc' }
      }
        .each do |key, conditions|
          selected = conditions.all? { |k,v| params[k].eql? v }
          result.push [
            t(key, scope: :paginator),
            url_for(params.merge(conditions).reject { |k, v| v.nil? }),
            selected ? {selected: :selected} : {}
          ]
        end
    end
    options_for_select options
  end
end
