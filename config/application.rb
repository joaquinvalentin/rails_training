# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Training
  # Application class
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.database_url = ENV.fetch('DATABASE_URL')

    config.smtp_user_name = ENV.fetch('SMTP_USER_NAME')
    config.smtp_password = ENV.fetch('SMTP_PASSWORD')
    config.domain = ENV.fetch('DOMAIN')
    config.smtp_address = ENV.fetch('SMTP_ADDRESS')
    config.smtp_port = ENV.fetch('SMTP_PORT')

    # Autoload lib folder
    config.eager_load_paths << Rails.root.join('lib')
    if Rails.env.test?
      RSpec.configure do |config|
        config.swagger_dry_run = false
      end
    end

    # To add a CMS with API-Only mode
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
  end
end
