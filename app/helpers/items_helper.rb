module ItemsHelper
  def item_field(name, options = {}, &block)
    value = @item.send name
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

  def item_thumbnail(item)
    default = Settings.ui.items.default_thumbnails
    image_type =  Array(default.image).include?(item.type) ? 'icon-image.gif' :
                  Array(default.sound).include?(item.type) ? 'icon-sound.gif' :
                  Array(default.video).include?(item.type) ? 'icon-video.gif' :
                                                             'icon-text.gif'
    if item.preview_image.present?
      image_tag item.preview_image, onerror: 'image_loading_error(this);', default_uri: asset_path(image_type)
    else
      image_tag image_type
    end
  end
end