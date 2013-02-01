module ItemsHelper
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
          url_for(params.merge(page_size: size)),
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
        a2z:       { sort_by: 'subject.name', sort_order: 'asc' },
        z2a:       { sort_by: 'subject.name', sort_order: 'desc' },
        old2new:   { sort_by: 'created.start', sort_order: 'asc' },
        new2old:   { sort_by: 'created.start', sort_order: 'desc' }
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

  def refine_path(area, value, options = {})
    existing_refine = params[area] || []
    existing_refine = Array(existing_refine)
    refine_params = options[:remove] ? existing_refine - [value] : existing_refine + [value]
    params.deep_merge(area => refine_params.uniq)
  end

  def preserved_search_fields(options = {})
    preservable = [:q, :subject, :type, :after, :before, :page_size, :sort_by, :sort_order]
    to_preserve = preservable - Array(options[:without])
    ''.tap do |html|
      to_preserve.each do |field|
        if params[field].is_a? Array
          params[field].each { |value| html << hidden_field_tag("#{field}[]", value) if value.present? }
        elsif params[field].is_a? Hash
          params[field].each { |subfield,value| html << hidden_field_tag("#{field}[#{subfield}]", value) if value.present? }
        elsif params[field]
          html << hidden_field_tag(field, params[field])
        end
      end
    end.html_safe
  end
end