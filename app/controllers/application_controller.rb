class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_common_variables

  def after_sign_in_path_for(resource)
    puts '############################'
    puts resource.last_sign_in_at
    puts '############################'
    puts Date.today
    # if resource.last_sign_in_at == resource.current_sign_in_at or resource.last_sign_in_at < Date.today
    resource.update(exp: resource.exp + @login_exp, book_todo_count: @book_todo_count, book_done_count: @book_done_count)
    # end
    log=LoginHistory.find_by(login_at: Date.today)
    if !log
      log=LoginHistory.new(user_id: current_user.id,login_at: Date.today)
      log.save
    end
    user_path(resource)
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end

  def set_common_variables
    @login_exp = 30
    @book_done_exp = 10
    @book_todo_exp = 3
    @book_done_count = 5
    @book_todo_count = 5
  end
end
