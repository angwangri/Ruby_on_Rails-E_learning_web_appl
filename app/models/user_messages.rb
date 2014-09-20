class UserMessages < ActiveRecord::Base
	belongs_to :user
	validates :sender_email, presence: true
	validates :sender_name, presence: true
	validates :sender_phone, presence: true
	validates :message, presence: true

	attr_accessible :sender_phone, :sender_name, :sender_email, :message, :user_id, :key, :student_id
end
