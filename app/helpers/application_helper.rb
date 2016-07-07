module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def exhibitions_path
    Settings.exhibitions.site
  end

  def wordpress_path(path = '')
    Settings.wordpress.site + path
  end

  def is_admin?
    user_signed_in? && current_user.is_admin?
  end

  def branding_stylesheets
    stylesheet_link_tag('dpla-colors') + stylesheet_link_tag('dpla-fonts') if defined? DplaFrontendAssets
  end

  def branding_img(image_name)
    if defined? DplaFrontendAssets
      case image_name
      when 'logo.png'
        'dpla-logo.png'
      when 'footer-logo.png'
        'dpla-footer-logo.png'
      else
        image_name
      end
    else
      image_name
    end
  end

  def view_object_link(item)
    return unless item.url.present?

    type = Array.wrap(item.type)
    data_provider = Array.wrap(item.data_provider)

    type_name = 'item'
    type_name = type.last if type.count == 1

    ci_name = 'contributing institution'
    ci_name = data_provider.join(', ') if data_provider.present?

    link = link_to item.url, target: :_blank, class: 'ViewObject' do
      "Get full #{type_name} from #{ci_name}" \
      '<span class="icon-view-object" aria-hidden="true"></span>'.html_safe
    end
  end
end
