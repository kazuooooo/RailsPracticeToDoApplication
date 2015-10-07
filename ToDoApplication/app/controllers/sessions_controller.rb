class SessionsController < ApplicationController
	def new
		render 'new'
  end

  def create
    user =  User.find_by(mailaddress: params[:session][:mailaddress])

    #binding.pry
    if user && user.password == params[:session][:password]
      #binding.pry
      redirect_to tasks_path, notice: 'ログインしました'
      session[:user_id] = user.id 
    else
      #binding.pry
      redirect_to root_path, notice: 'ログインに失敗しました'
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
