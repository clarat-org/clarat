require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clarat
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{config.root}/app/objects/form/
      #{config.root}/app/objects/errors/
      #{config.root}/app/objects/service/
      #{config.root}/app/objects/value/
      #{config.root}/app/objects/queries/
      #{config.root}/app/models/filters/
    )

    # Activate observers that should always be running.
    config.active_record.observers = %w(
      subscription_observer offer_observer organization_observer
    )

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    # Default is UTC.
    config.time_zone = 'Berlin'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.generators.assets :controller_based_assets
    config.generators.test_framework :minitest, spec: true

    # Rack extensions
    config.middleware.use Rack::Attack

    # Middleware for JS-Translations
    config.middleware.use I18n::JS::Middleware

    # specific test order (default in Rails 5) to silence deprecation warnings
    config.active_support.test_order = :random

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }

  end
end
