class RegistrationsController < Devise::RegistrationsController

#  def after_inactive_sign_up_path_for(resource)
#  	sign_in(resource_name, resource)
#    "http://somewhere.com"
#  end

#  def after_sign_up_path_for(resource)
#    '/an/example/path'
#  end

  def after_sign_up_path_for(resource)
  	set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
    welcome_path
  end

end 