require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module SouFudao
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Beijing'
    #config.active_record.default_timezone = 'Beijing (Asia/Shanghai)'

    config.assets.initialize_on_precompile = false

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.assets.enabled = true

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.assets.precompile += Dir[Rails.root.join('locales', '*.css').to_s]
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    # config.i18n.default_locale = :de
    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
    :address              => "mail.privateemail.com",
    :port                 => 465,
    :domain               => 'www.soufudao.com',
    :user_name            => 'admin@soufudao.com',
    :password             => 'soufudao',
    :authentication       => :login,
    :ssl                  => true
      }
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true

  end
end
