class HomeController < ApplicationController  
  
  before_filter :redirect_to_tasks, if: :user_signed_in?, only: :index
  before_filter :redirect_to_login, unless: :user_signed_in?, only: :index

  def index
  end
  
  private

  def root_page?
    return '/' === request.env["PATH_INFO"]
  end

  def redirect_to_tasks
    redirect_to tasks_url
  end

  def redirect_to_login
    redirect_to new_user_session_url
  end
end
