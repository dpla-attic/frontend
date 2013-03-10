module TimelineHelper
  def timeline(years, height = 30)
    decades = {}
    years.each_pair do |year, count|
      current = year.to_i
      decade = current - current % 10
      decades[decade.to_s] = (decades[decade.to_s] || 0) + count
    end

    max_count = 0
    max_count = decades.sort{|a,b| a[1] <=> b[1]}.last.last unless decades.empty?

    content_tag(:div, '', class: 'scrubber').html_safe +

    content_tag(:ul, class: 'centuries') do
      (1000..Time.now.year).step(100).collect do |century|
        content_tag(:li, century)
      end.join.html_safe
    end.html_safe +

    content_tag(:ul, class: 'bars') do
      (1000..Time.now.year).step(10).collect do |year|
        col_height = 1 + Math.log(decades[year.to_s].to_i, max_count+2) * height
        content_tag(:li, "", style: "height: #{col_height}px;")
      end.join.html_safe
    end.html_safe
  end

  def graph_dates
    content_tag(:ul, '') do
      (1000..2019).step(10).collect do |decade|
        content_tag(:li, decade, class: ("century" if decade % 100 == 0))
      end.join.html_safe
    end
  end

  def graph(years, height = 300)
    max_count = 0
    max_count = years.sort{|a,b| a[1] <=> b[1]}.last.last unless years.empty?

    content_tag(:ul, '') do
      (1000..2019).collect do |year|
        if year <= Time.now.year
          count = years[year.to_s] || 0
          col_height = (count > 0 ? 25 : 1) + Math.log(count, max_count+2) * height
          content_tag(:li,
              content_tag(:div,
                content_tag(:div, "<h3>#{year}</h3><span>#{count} items</span>".html_safe, class: "info"),
                class: "infoOuter"),
            style: "height: #{col_height}px;")
        else
          content_tag(:li, "", style: "visibility: hidden;")
        end

      end.join.html_safe
    end
  end

end