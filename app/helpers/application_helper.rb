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

end
