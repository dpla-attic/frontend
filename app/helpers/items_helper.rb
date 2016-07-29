module ItemsHelper

  ##
  # Generate an HTML list for a metadata field.
  #
  # @param name [String] the name of the metadata field, as defined in the Item
  # model.
  #
  # @param options [Hash]
  #   :title = Display title for the metadata field (if different from name).
  #   :facet = Name of the field as it is used as a facet in the API. If there
  #            is a value for :facet, the values will be linked to a faceted
  #            search query.
  #
  # @return [String] HTML
  def item_field(name, options = {}, &block)
    value = [@item.send(name)].flatten
    value.reject!(&:blank?)
    title = options[:title] || name.to_s.split('_').map(&:capitalize).join(' ')
    facet = options[:facet]

    if value.present?
      content_tag(:ul) do
        content_tag(:li, content_tag(:h6, title)) +
        if block_given?
          content_tag(:li) do
            block.call
          end
        else
          if facet.present?
            content_tag(:li) do
              value.map do |v|
                link_to v, search_path(facet => v)
              end.join("<br/>").html_safe
            end
          else
            content_tag(:li) do
              value.map do |v|
                Rinku.auto_link(v, :urls, 'target="_blank"')
              end.join("<br />").html_safe
            end
          end
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

  def item_thumbnail(item, request)
    image_type = item_type_image(item)
    if item.preview_image.present?
      if request.ssl?
        image_tag item.preview_image_ssl,
                  onerror: 'this.src=this.getAttribute("data-default-src");',
                  data: { 'default-src' => asset_path(image_type) }
      else
        image_tag item.preview_image,
                  onerror: 'this.src=this.getAttribute("data-default-src");',
                  data: { 'default-src' => asset_path(image_type) }
      end
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
