class HomeController < ApplicationController  
  before_action :redirect_to_task_index_if_login_rememberd

  def redirect_to_task_index_if_login_rememberd
    if user_signed_in? && root_page?
      redirect_to tasks_path
    end
  end

  private

  def root_page?
    return '/' === request.env["PATH_INFO"]
  end

end
