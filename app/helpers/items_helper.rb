module ItemsHelper
  def item_field(name, options = {}, &block)
    value = @item.send name
    title = options[:title] || name.to_s.capitalize.gsub('_', ' ')

    if value.present?
      content_tag(:ul) do
        content_tag(:li, content_tag(:h6, title)) +
        if block_given?
          content_tag(:li) do
            block.call
          end
        elsif value.is_a? Array
          content_tag(:li, value.join("<br />").html_safe)
        else
          content_tag(:li, value)
        end
      end
    end
  end
end