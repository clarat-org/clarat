Rails.application.configure do
  I18n.config.enforce_available_locales = false
  I18n.available_locales = [:en, :de]

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  config.i18n.default_locale = :de
end
