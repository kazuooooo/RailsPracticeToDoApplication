class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :logged_in?

  protect_from_forgery with: :exception
  include SessionsHelper

  def logged_in?
  		!!session[:user_id]
  end
end
