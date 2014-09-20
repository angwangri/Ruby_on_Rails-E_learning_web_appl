class Subscription < ActiveRecord::Base
	belongs_to :user
	attr_accessible :user_id, :yapi_tid, :tid, :item_price , :item_currency , 
					:subscription_type, :result_status, :result_desc , :start_date, :status

	#set Profile status
	ACTIVE = "active"
	CANCEL = "cancelled"
	# set subscription period
	MONTH = "monthly"
	YEAR = "yearly"	

	REQUEST_URL = "https://yoopay.cn/yapi"
	SELLER_EMAIL = "bparrish46@gmail.com"	
	TYPE = 'CHARGE'
	ITEM_CURRENCY = 'CNY' # USD

	# 1 - Online Banking (China Union Pay)
	# 2 - Alipay
	# 3 - China Bank Transfer
	# 4 - Oversea Bank Transfer
	# 5 - Credit Card
	# 6 - Paypal
    PAYMENT_METHOD = '1;2;5;6'

    NOTIFY_URL = "#{ActionMailer::Base.default_url_options[:host]}/notify_url"
    RETURN_URL = "#{ActionMailer::Base.default_url_options[:host]}/return_url"
    INVOICE = '0'

    APP_KEY = '788e775e1c8c5d0864ee7b324b8711b6'

    SANDBOX_MODE = true


	def self.generete_payment_url(payment_type, user_id, language)
		user = User.find(user_id)
	    tid = Time.now.strftime("%d%m%Y%H%M") #unique transaction id
	    Subscription.create(:user_id => user_id, :tid => tid, :subscription_type => payment_type)
	    language = language
	    item_name = payment_type == 'monthly' ? 'Monthy subscription' : 'Yearly subscription'
		item_body = payment_type == 'monthly' ? 'Monthy subscription for using premium services.' : 'Yearly subscription for using premium services.'
	    item_price = payment_type == 'monthly' ? '60.00' : '600.00'
	    customer_name = user.fullname
	    customer_email = user.email
	    if SANDBOX_MODE
	    	sandbox = '1'
	    	sandbox_target_status = '1' #-1 - expect a failed response, 0 - expect a pending response, 1 - expect a successful response
	    else
	    	sandbox = '0'
		end

	    #generate signature
	    sign_str = APP_KEY + SELLER_EMAIL + tid + item_price + ITEM_CURRENCY + NOTIFY_URL + sandbox + INVOICE
	    sign_str = sign_str.upcase
	    sign = Digest::MD5.hexdigest(sign_str)


	    @toSend = {
	      "seller_email" => SELLER_EMAIL,
	      "language" => language,
	      "type" => TYPE,
	      "sign" => sign,
	      "tid" => tid,
	      "item_name" => item_name,
	      "item_body" => item_body,
	      "item_price" => item_price,
	      "item_currency" => ITEM_CURRENCY,
	      "payment_method" => PAYMENT_METHOD,
	      "customer_name" => customer_name,
	      "customer_email" => customer_email,
	      "sandbox" => sandbox,
	      "notify_url" => NOTIFY_URL,
	      "return_url" => RETURN_URL,
	      "invoice" => INVOICE
	    }

	    if SANDBOX_MODE
	    	@toSend["sandbox_target_status"] = '1'
	    end

	    REQUEST_URL+"?#{@toSend.to_query}"
	end

end
