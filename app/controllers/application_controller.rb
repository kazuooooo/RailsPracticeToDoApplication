class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :edit_page?

  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    tasks_path
  end

  def after_sign_out_path_fir(resource)
    tasks_path
  end
end
