class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_admin!
    if !user_signed_in?
      redirect_to :new_user_session
    else
      redirect_to :root if !current_user.is_admin?
    end
  end
end
