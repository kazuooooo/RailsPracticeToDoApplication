class User < ActiveRecord::Base
	validates :mailaddress, presence: true
	validates :password, presence: true
end
