class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :sanitize_back_uri!
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

  ##
  # Forbid the request if the back_uri parameter is being set to create
  # offsite links.  The parameter is used in various views throughout the
  # application.
  def sanitize_back_uri!
    if params[:back_uri].present?
      ok = request.protocol + request.host
      render nothing: true, status: 403 if !params[:back_uri].start_with? ok
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

  def render_503
    render nothing: true, status: 503
  end
end
