module SearchHelper
  def preserved_search_fields(options = {})
    preservable = [:q, :subject, :type, :start, :end, :page_size, :sort_by, :sort_order]
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

  def timeline(decades, height = 30)
    h = {}
    max_count = decades.sort{|a,b| a[1] <=> b[1]}.last.last unless decades.empty?
    (1000..Time.now.year).step(10).each do |year|
      if decades[year.to_s]
        h["#{year}"] = decades[year.to_s].to_i / max_count.to_f * height
      else
        h["#{year}"] = 0
      end
    end

    content_tag(:div, '', class: 'scrubber').html_safe +

    content_tag(:ul, class: 'centuries') do
      (1000..Time.now.year).step(100).collect do |century|
        content_tag(:li, century)
      end.join.html_safe
    end.html_safe +

    content_tag(:ul, class: 'bars') do
      h.collect do |key, value|
        content_tag(:li, "", style: "height: #{5+value}px;")
      end.join.html_safe
    end.html_safe
  end

  def graph_dates
    content_tag(:ul, '') do
      (1000..Time.now.year).step(10).collect do |decade|
        content_tag(:li, decade, class: ("century" if decade % 100 == 0))
      end.join.html_safe
    end
  end

  def graph(years, height = 300)
    max_count = years.sort{|a,b| a[1] <=> b[1]}.last.last unless years.empty?

    content_tag(:ul, '') do
      (1000..Time.now.year).collect do |year|
        count = years[year.to_s] || 0
        content_tag(:li,
            if count > 0
            content_tag(:div, 
              content_tag(:div, "<h3>#{year}</h3><span>#{count} items</span>".html_safe, class: "info"),
              class: "infoOuter")
            end,
          style: "height: #{25+count/max_count.to_f*height}px;")

      end.join.html_safe
    end
  end

end