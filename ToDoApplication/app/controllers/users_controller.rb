class UsersController < ApplicationController
	def login
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to new_session_path, notice: '作成しました'
		else
			render :new
		end
	end



	private 

	def user_params
		params[:user].permit(:mailaddress,:password)
	end
end
