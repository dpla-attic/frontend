class PasswordsController < Devise::PasswordsController
  def create
    respond_to do |format|
      format.html { super }
      format.json do
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
        return sign_in_and_redirect(resource_name, resource)
      end
    end
  end
end