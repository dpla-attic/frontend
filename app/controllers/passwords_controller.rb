class PasswordsController < Devise::PasswordsController
  after_filter :set_cache_flag!

  def set_cache_flag!
    flag = Settings.session.logged_in_flag.to_sym
    cookies[flag] = { value: 1, httponly: true } if not cookies[flag]
  end
end
