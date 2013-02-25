class RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
  	set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
    welcome_path
  end

end