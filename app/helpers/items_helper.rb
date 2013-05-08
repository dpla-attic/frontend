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

  def item_thumbnail(item)
    if item.preview_image.present?
      image_tag item.preview_image, onerror: 'image_loading_error(this);'
    else
      default = Settings.ui.items.default_thumbnails
      case
      when Array(default.image).include?(item.type) then image_tag 'icon-image.gif'
      when Array(default.sound).include?(item.type) then image_tag 'icon-sound.gif'
      when Array(default.video).include?(item.type) then image_tag 'icon-video.gif'
      else image_tag 'icon-text.gif'
      end
    end
  end
end