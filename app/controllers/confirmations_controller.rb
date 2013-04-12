class ConfirmationsController < Devise::ConfirmationsController
  after_filter :set_cache_flag!

  def after_confirmation_path_for(resource_name, resource)
    welcome_path
  end

  def set_cache_flag!
    flag = Settings.session.logged_in_flag.to_sym
    cookies[flag] = { value: 1, httponly: true } if not cookies[flag]
  end
end
