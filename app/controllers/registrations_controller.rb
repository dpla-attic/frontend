class RegistrationsController < Devise::RegistrationsController
  after_filter :set_cache_flag!

  def after_sign_up_path_for(resource)
  	set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
    welcome_path
  end

  def set_cache_flag!
    flag = Settings.session.logged_in_flag.to_sym
    cookies[flag] = { value: 1, httponly: true } if not cookies[flag]
  end

  def new
    resource = build_resource({})
    render request.xhr? ? { partial: 'shared/modals/signup', layout: false } : {}
  end
end
