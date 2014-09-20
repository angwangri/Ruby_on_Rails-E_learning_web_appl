class PaypalPayment < ActiveRecord::Base
	belongs_to :user
	attr_accessible :user_id, :token, :profile_id, :payer_id, :subscription_type, :profile_status, :start_date

	#set Profile status
	ACTIVE = "active"
	CANCEL = "cancelled"

	# set subscription period
	MONTH = "monthly"
	YEAR = "yearly"
end
