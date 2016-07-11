module SearchHelper
  def preserved_search_fields(options = {})
    preservable = [
      :q, :subject, :language, :type, :provider, :partner,
      :place, :country, :state, :after, :before,
      :page_size, :sort_by, :sort_order,
    ]
    to_preserve = preservable - Array(options[:without])
    ''.tap do |html|
      to_preserve.each do |field|
        if params[field].is_a? Array
          params[field].each { |value| html << hidden_field_tag("#{field}[]", value, id: nil) if value.present? }
        elsif params[field].is_a? Hash
          params[field].each { |subfield,value| html << hidden_field_tag("#{field}[#{subfield}]", value, id: nil) if value.present? }
        elsif params[field]
          html << hidden_field_tag(field, params[field], id: nil)
        end
      end
    end.html_safe
  end

  def link_to_exhibition(exhibition)
    href = [Settings.exhibitions.site, 'exhibits', 'show', exhibition.slug].join('/')
    link_to exhibition.title, href
  end

  def link_to_subject(subject)
    link_to subject, search_path(subject: subject)
  end
end
