require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clarat
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{config.root}/app/objects/form/
      #{config.root}/app/objects/errors/
      #{config.root}/app/observers
    )

    # Activate observers that should always be running.
    config.active_record.observers = %w(location_observer)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    I18n.config.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.initialize_on_precompile = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'

    # Enable fonts directory
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
    #config.assets.precompile += Dir["app/assets/stylesheets/controller/*.scss"].map{|file| "controller/#{File.basename file,'.scss'}" }
    config.assets.precompile += %w( gmaps_search_results.js vendor/modernizr.custom.js )
    config.generators.assets :controller_based_assets

    config.generators.test_framework :minitest, spec: true

    # Rack extensions
    config.middleware.use Rack::Attack

    # TODO: put in initializer
    OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'TLSv1'
  end
end
