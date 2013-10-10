class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :set_cache_flag!
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Exception, with: :render_500

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

  def render_404
    render 'pages/error_404', status: 404
  end

  def render_500
    render 'pages/error_500', status: 500
  end
end
