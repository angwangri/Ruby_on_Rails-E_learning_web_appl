class UserLanguage < ActiveRecord::Base
	belongs_to :user
	attr_accessible :user_id, :lang_spoken, :english_rate, :chinese_rate, :nationality
end
