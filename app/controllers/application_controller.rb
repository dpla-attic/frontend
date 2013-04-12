class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :set_cache_flag!

  def authenticate_admin!
    if !user_signed_in?
      redirect_to :new_user_session
    else
      redirect_to :root if !current_user.is_admin?
    end
  end

  def set_cache_flag!
    flag = Settings.session.logged_in_flag.to_sym
    if current_user
      cookies[flag] = { value: 1, httponly: true } if not cookies[flag]
    else
      cookies.delete flag
    end
  end
end
