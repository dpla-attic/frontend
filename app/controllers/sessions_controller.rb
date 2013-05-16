class SessionsController < Devise::SessionsController
  after_filter :set_cache_flag!

  def set_cache_flag!
    flag = Settings.session.logged_in_flag.to_sym
    cookies[flag] = { value: 1, httponly: true } if not cookies[flag]
  end

  def new
    self.resource = build_resource(nil, unsafe: true)
    clean_up_passwords(resource)
    render request.xhr? ? { partial: 'shared/modals/login', layout: false } : {}
  end
end
