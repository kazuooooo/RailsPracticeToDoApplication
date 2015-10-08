class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  #新規登録か通常ログインなのかを判定
  def self.from_omniauth(auth)
  	where(auth.slice(:provider, :uid).to_hash).first_or_create do |user|
  		binding.pry
  		user.email = auth.info.email
  		user.password = Devise.friendly_token[0,20]
  	end
  end

  def self.new_with_session(params, session)
  	super.tap do |user|
  		if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  		user.email = data["email"] if user.email.blank?
  		end
  	end
  end

end