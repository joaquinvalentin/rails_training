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
# require "sprockets/railtie"
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

    # Database variables for testing
    config.database_name_testing = ENV.fetch('DATABASE_NAME_TESTING')
    config.database_user_testing = ENV.fetch('DATABASE_USER_TESTING')
    config.database_password_testing = ENV.fetch('DATABASE_PASSWORD_TESTING')
    config.database_url_testing = ENV.fetch('DATABASE_URL_TESTING')

    # Database variables for development
    config.database_name = ENV.fetch('DATABASE_NAME')
    config.database_user = ENV.fetch('DATABASE_USER')
    config.database_password = ENV.fetch('DATABASE_PASSWORD')
    config.database_url = ENV.fetch('DATABASE_URL')

    # Autoload lib folder
    config.eager_load_paths << Rails.root.join('lib')
    if Rails.env.test?
      RSpec.configure do |config|
        config.swagger_dry_run = false
      end
    end
  end
end
