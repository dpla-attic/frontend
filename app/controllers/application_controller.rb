class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_admin!
    redirect_to :new_user_session unless user_signed_in? && current_user.is_admin?
  end
end
