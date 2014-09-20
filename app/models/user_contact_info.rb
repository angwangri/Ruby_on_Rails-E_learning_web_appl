class UserContactInfo < ActiveRecord::Base
	belongs_to :user
	attr_accessible :id, :user_id, :qq_chat_id, :skype_id, :we_chat_id, :phone
end
