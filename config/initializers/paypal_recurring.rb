require "paypal/recurring"
KEYS = YAML::load(File.open("#{Rails.root}/config/paypal_credentials.yml"))
PayPal::Recurring.configure do |config|
  config.sandbox = KEYS["#{Rails.env}"]["sandbox"]
  config.username = KEYS["#{Rails.env}"]["username"]
  config.password = KEYS["#{Rails.env}"]["password"]
  config.signature = KEYS["#{Rails.env}"]["signature"]
end