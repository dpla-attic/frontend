module ItemsHelper
  def item_field(name, options = {}, &block)
    value = @item.send name
    value.reject!(&:blank?) if value.is_a? Array
    title = options[:title] || name.to_s.split('_').map(&:capitalize).join(' ')

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

  def item_type_image(item)
    default = Settings.ui.items.default_thumbnails
    case
    when Array(default.image).include?(item.type) then image_type = 'icon-image.gif'
    when Array(default.sound).include?(item.type) then image_type = 'icon-sound.gif'
    when Array(default.video).include?(item.type) then image_type = 'icon-video.gif'
    else image_type = 'icon-text.gif'
    end
    image_type
  end

  def item_thumbnail(item)
    image_type = item_type_image(item)
    if item.preview_image.present?
      image_tag item.preview_image, onerror: 'this.src=this.getAttribute("data-default-src");', data: { 'default-src' => asset_path(image_type) }
    else
      image_tag image_type
    end
  end

  def item_thumbnail_url(item)
    if item.preview_image.present?
      item.preview_image
    else
      asset_path(item_type_image(item))
    end
  end

  def item_ogp_meta(item)
    ogp = {}
    ogp[:image] = item_thumbnail_url(@item)
    partner = item.data_provider.present? ? item.data_provider : item.provider
    ogp[:description] = "Source: #{partner}."
    if item.creator.present?
      ogp[:description] += " Creator: #{item.creator}."
    end
    if item.description.present?
      ogp[:description] += " #{item.description}"
    end
    ogp
  end
end