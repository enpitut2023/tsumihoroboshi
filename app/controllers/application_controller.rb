class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  def after_sign_in_path_for(resource)
    puts '############################'
    puts resource.last_sign_in_at
    puts '############################'
    puts Date.today
    # if resource.last_sign_in_at == resource.current_sign_in_at or resource.last_sign_in_at < Date.today
    resource.update(exp: resource.exp + 20)
    # end
    user_path(resource)
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
